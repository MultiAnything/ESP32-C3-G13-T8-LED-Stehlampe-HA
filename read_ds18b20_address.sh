#!/bin/bash
# Script zum Auslesen der DS18B20 Sensor-Adresse

set -e

echo "=========================================="
echo "DS18B20 Adresse auslesen"
echo "=========================================="
echo ""

# Prüfe ob Gerät angeschlossen ist
DEVICE=""
if [ -e "/dev/ttyACM0" ]; then
    DEVICE="/dev/ttyACM0"
elif [ -e "/dev/ttyACM1" ]; then
    DEVICE="/dev/ttyACM1"
elif [ -e "/dev/ttyUSB0" ]; then
    DEVICE="/dev/ttyUSB0"
elif [ -e "/dev/ttyUSB1" ]; then
    DEVICE="/dev/ttyUSB1"
else
    echo "❌ Kein USB-Gerät gefunden!"
    echo "Bitte ESP32-C3 per USB anschließen."
    exit 1
fi

echo "✅ Gerät gefunden: $DEVICE"
echo ""

# Aktiviere virtuelle Umgebung
if [ -d "esphome-env" ]; then
    source esphome-env/bin/activate
else
    echo "❌ Virtuelle Umgebung nicht gefunden!"
    echo "Führe zuerst aus: ./install_esphome.sh"
    exit 1
fi

# Erstelle temporäre Konfiguration zum Auslesen der Adresse
TEMP_CONFIG="temp_read_address.yaml"
cat > "$TEMP_CONFIG" << 'EOF'
substitutions:
  name: temp-read-address

esphome:
  name: ${name}
  friendly_name: Temp Read Address

esp32:
  board: esp32-c3-devkitm-1
  framework:
    type: arduino

logger:
  level: INFO

api:

wifi:
  ap:
    ssid: "Temp-Read-AP"

one_wire:
  - platform: gpio
    pin: GPIO4

sensor:
  - platform: dallas_temp
    name: "DS18B20 Temp"
    update_interval: 5s

EOF

echo "1. Kompiliere temporäre Konfiguration..."
if esphome compile "$TEMP_CONFIG" > /dev/null 2>&1; then
    echo "✅ Kompilierung erfolgreich"
else
    echo "❌ Kompilierung fehlgeschlagen"
    rm -f "$TEMP_CONFIG"
    exit 1
fi

echo ""
echo "2. Flashe temporäre Firmware..."
if esphome upload "$TEMP_CONFIG" --device "$DEVICE" > /dev/null 2>&1; then
    echo "✅ Firmware geflasht"
else
    echo "❌ Flash fehlgeschlagen"
    rm -f "$TEMP_CONFIG"
    exit 1
fi

echo ""
echo "3. Warte auf Boot (10 Sekunden)..."
sleep 10

echo ""
echo "4. Lese Logs und suche nach Sensor-Adresse..."
echo "   (Drücke Ctrl+C zum Abbrechen)"
echo ""

# Lese Logs und suche nach der Adresse
ADDRESS=""
TIMEOUT=60
START_TIME=$(date +%s)

# Starte Logs im Hintergrund und sammle Output
LOG_FILE=$(mktemp)
timeout $TIMEOUT esphome logs "$TEMP_CONFIG" --device "$DEVICE" > "$LOG_FILE" 2>&1 &
LOG_PID=$!

while [ -z "$ADDRESS" ]; do
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    
    if [ $ELAPSED -gt $TIMEOUT ]; then
        kill $LOG_PID 2>/dev/null || true
        echo ""
        echo "❌ Timeout: Sensor-Adresse nicht gefunden"
        echo ""
        echo "Letzte Logs:"
        tail -20 "$LOG_FILE" 2>/dev/null || true
        echo ""
        echo "Mögliche Ursachen:"
        echo "- DS18B20 nicht an GPIO4 angeschlossen"
        echo "- Sensor defekt oder falsch verdrahtet"
        echo "- Pull-up Widerstand fehlt (4.7kΩ zwischen Daten und VCC)"
        rm -f "$TEMP_CONFIG" "$LOG_FILE"
        exit 1
    fi
    
    # Suche nach Adresse in verschiedenen Formaten
    if [ -f "$LOG_FILE" ]; then
        # Format: 0x1234567812345628
        ADDRESS=$(grep -oE '0x[0-9a-fA-F]{16}' "$LOG_FILE" | head -1 || true)
        
        # Format: Address: 0x...
        if [ -z "$ADDRESS" ]; then
            ADDRESS=$(grep -oE 'Address: 0x[0-9a-fA-F]{16}' "$LOG_FILE" | grep -oE '0x[0-9a-fA-F]{16}' | head -1 || true)
        fi
        
        # Format: Found device 0x...
        if [ -z "$ADDRESS" ]; then
            ADDRESS=$(grep -oE 'Found device 0x[0-9a-fA-F]{16}' "$LOG_FILE" | grep -oE '0x[0-9a-fA-F]{16}' | head -1 || true)
        fi
        
        # Format: Device 0x... (ohne führendes 0x)
        if [ -z "$ADDRESS" ]; then
            ADDRESS=$(grep -oE 'Device [0-9a-fA-F]{16}' "$LOG_FILE" | grep -oE '[0-9a-fA-F]{16}' | sed 's/^/0x/' | head -1 || true)
        fi
    fi
    
    if [ -n "$ADDRESS" ]; then
        kill $LOG_PID 2>/dev/null || true
        break
    fi
    
    echo -n "."
    sleep 2
done

# Warte kurz auf Log-Process
wait $LOG_PID 2>/dev/null || true

echo ""
echo ""

if [ -n "$ADDRESS" ]; then
    echo "✅ Sensor-Adresse gefunden: $ADDRESS"
    echo ""
    
    # Speichere Adresse in Datei
    ADDRESS_FILE="ds18b20_address.txt"
    echo "$ADDRESS" > "$ADDRESS_FILE"
    echo "✅ Adresse gespeichert in: $ADDRESS_FILE"
    echo ""
    
    # Zeige Inhalt
    echo "Adresse:"
    cat "$ADDRESS_FILE"
    echo ""
    
    echo "=========================================="
    echo "✅ Erfolgreich abgeschlossen!"
    echo "=========================================="
    echo ""
    echo "Die Adresse wurde in '$ADDRESS_FILE' gespeichert."
    echo "Aktualisiere jetzt g13_led_stehlampe_ha.yaml mit dieser Adresse."
else
    echo "❌ Sensor-Adresse konnte nicht ermittelt werden"
    echo ""
    echo "Mögliche Ursachen:"
    echo "- DS18B20 nicht an GPIO4 angeschlossen"
    echo "- Sensor defekt"
    echo "- Verbindungsproblem"
fi

# Aufräumen
rm -f "$TEMP_CONFIG"

echo ""

