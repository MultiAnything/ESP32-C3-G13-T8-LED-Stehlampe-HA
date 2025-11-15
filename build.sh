#!/bin/bash
# ESPHome Build Script
# Kompiliert und flasht die Firmware

set -e  # Stoppe bei Fehlern

# Konfigurationsdatei
CONFIG_FILE="g13_led_stehlampe_ha.yaml"

# Prüfe ob virtuelle Umgebung existiert
if [ ! -d "esphome-env" ]; then
    echo "❌ Virtuelle Umgebung nicht gefunden!"
    echo "Führe zuerst aus: ./install_esphome.sh"
    exit 1
fi

# Aktiviere virtuelle Umgebung
source esphome-env/bin/activate

# Prüfe ob ESPHome installiert ist
if ! command -v esphome &> /dev/null; then
    echo "❌ ESPHome nicht gefunden!"
    echo "Führe zuerst aus: ./install_esphome.sh"
    exit 1
fi

echo "=========================================="
echo "ESPHome Build Script"
echo "=========================================="
echo ""

# Validiere Konfiguration
echo "1. Validiere Konfiguration..."
if esphome config "$CONFIG_FILE" > /dev/null 2>&1; then
    echo "✅ Konfiguration ist gültig"
else
    echo "❌ Konfigurationsfehler gefunden!"
    esphome config "$CONFIG_FILE"
    exit 1
fi
echo ""

# Kompiliere
echo "2. Kompiliere Firmware..."
if esphome compile "$CONFIG_FILE"; then
    echo "✅ Kompilierung erfolgreich!"
else
    echo "❌ Kompilierung fehlgeschlagen!"
    exit 1
fi
echo ""

# Frage ob geflasht werden soll
read -p "Firmware jetzt flashen? (j/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Jj]$ ]]; then
    echo ""
    echo "3. Flashe Firmware..."
    echo "Verfügbare Geräte:"
    ls -la /dev/ttyUSB* /dev/ttyACM* 2>/dev/null || echo "Keine USB-Geräte gefunden"
    echo ""
    read -p "Gerät (z.B. /dev/ttyUSB0) oder Enter für automatisch: " DEVICE
    
    if [ -z "$DEVICE" ]; then
        esphome upload "$CONFIG_FILE"
    else
        esphome upload "$CONFIG_FILE" --device "$DEVICE"
    fi
    
    if [ $? -eq 0 ]; then
        echo "✅ Firmware erfolgreich geflasht!"
    else
        echo "❌ Flash fehlgeschlagen!"
        exit 1
    fi
else
    echo ""
    echo "Firmware-Datei: .pioenvs/g13-led-ultraslim-stehlampe/firmware.bin"
    echo ""
    echo "Zum Flashen später ausführen:"
    echo "  esphome upload $CONFIG_FILE --device /dev/ttyUSB0"
fi

echo ""
echo "=========================================="
echo "✅ Fertig!"
echo "=========================================="

