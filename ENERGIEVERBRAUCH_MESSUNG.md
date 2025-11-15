# Energieverbrauch des ESP32-C3 messen

## Übersicht

Der ESP32-C3 kann seinen eigenen Energieverbrauch **nicht direkt** messen, da er keine integrierte Strommessung hat. Es gibt jedoch mehrere Möglichkeiten, den Verbrauch zu ermitteln.

## Option 1: Externe Strommesssensoren (INA219, INA226, INA260)

### Hardware-Anforderungen

- **INA219** (empfohlen für ESP32-C3)
  - I2C-Sensor
  - Misst: Spannung, Strom, Leistung
  - Genauigkeit: ±1% bei Strom bis 3.2A
  - Preis: ~2-5€

- **INA226** (für höhere Ströme)
  - I2C-Sensor
  - Misst: Spannung, Strom, Leistung
  - Genauigkeit: ±1% bei Strom bis 20A
  - Preis: ~3-6€

- **INA260** (integrierter Shunt)
  - I2C-Sensor
  - Kein externer Shunt-Widerstand nötig
  - Misst: Spannung, Strom, Leistung
  - Preis: ~4-8€

### Schaltungsaufbau

```
USB/5V ──[INA219]── ESP32-C3
         │
         └─ I2C (SDA/SCL)
```

Der INA219 muss **in Reihe** mit der Stromversorgung des ESP32-C3 geschaltet werden.

### ESPHome-Konfiguration (Beispiel INA219)

```yaml
# I2C Bus (falls noch nicht vorhanden)
i2c:
  sda: GPIO6  # Anpassen an deine Hardware
  scl: GPIO7  # Anpassen an deine Hardware
  scan: true

# INA219 Strommessung
sensor:
  - platform: ina219
    address: 0x40  # Standard I2C-Adresse
    shunt_resistance: 0.1 ohm  # Shunt-Widerstand (meist 0.1Ω)
    max_current: 3.2A  # Maximaler Strom
    max_voltage: 26V   # Maximale Spannung
    
    # Bus-Spannung (Versorgungsspannung)
    bus_voltage:
      name: "ESP32 Versorgungsspannung"
      unit_of_measurement: "V"
      accuracy_decimals: 2
      device_class: voltage
    
    # Stromverbrauch
    current:
      name: "ESP32 Stromverbrauch"
      unit_of_measurement: "A"
      accuracy_decimals: 3
      device_class: current
      state_class: measurement
    
    # Leistung
    power:
      name: "ESP32 Leistung"
      unit_of_measurement: "W"
      accuracy_decimals: 2
      device_class: power
      state_class: measurement
    
    # Energie (kumulativ)
    energy:
      name: "ESP32 Energieverbrauch"
      unit_of_measurement: "kWh"
      accuracy_decimals: 4
      device_class: energy
      state_class: total_increasing
    
    update_interval: 5s
```

### Vor- und Nachteile

**Vorteile:**
- ✅ Kontinuierliche Messung
- ✅ Integration in Home Assistant
- ✅ Historische Daten
- ✅ Genaue Messung

**Nachteile:**
- ❌ Zusätzliche Hardware nötig
- ❌ Schaltungsänderung erforderlich
- ❌ I2C-Verbindung nötig
- ❌ Zusätzlicher Stromverbrauch des Sensors (~1-2mA)

## Option 2: Externe Messgeräte

### Multimeter

- Einfachste Methode
- Strommessung in Reihe mit der Versorgung
- Nur Momentanwerte, keine kontinuierliche Überwachung

### USB Power Monitor

- USB-Strommessgerät zwischen USB-Kabel und ESP32
- Zeigt Spannung, Strom, Leistung an
- Keine Integration in ESPHome möglich

### Beispiele:
- **USB-C Power Meter** (für USB-C ESP32)
- **USB-A Power Meter** (für USB-A ESP32)
- Preis: ~5-15€

## Option 3: Schätzung basierend auf Betriebszustand

### Typische Verbrauchswerte ESP32-C3:

| Zustand | Stromverbrauch | Leistung (bei 5V) |
|---------|----------------|-------------------|
| Deep Sleep | ~10-50 µA | ~0.00005-0.00025 W |
| Light Sleep | ~0.5-1 mA | ~0.0025-0.005 W |
| Active (WiFi off) | ~15-30 mA | ~0.075-0.15 W |
| Active (WiFi on, idle) | ~50-80 mA | ~0.25-0.4 W |
| Active (WiFi TX) | ~80-150 mA | ~0.4-0.75 W |
| Active (WiFi RX) | ~60-100 mA | ~0.3-0.5 W |
| Active (CPU 100%) | ~40-60 mA | ~0.2-0.3 W |

### Template-Sensor für Schätzung

```yaml
sensor:
  - platform: template
    name: "ESP32 Geschätzter Verbrauch"
    lambda: |-
      // Schätzung basierend auf WiFi-Status
      if (id(wifi_signal_raw).state > -100) {
        // WiFi aktiv
        return 0.4;  // ~80mA bei 5V
      } else {
        // WiFi inaktiv
        return 0.15;  // ~30mA bei 5V
      }
    unit_of_measurement: "W"
    accuracy_decimals: 2
    device_class: power
    update_interval: 30s
```

## Option 4: ADC-basierte Messung (erweitert)

Falls ein Shunt-Widerstand in der Schaltung vorhanden ist, kann der ADC des ESP32-C3 verwendet werden:

```yaml
sensor:
  - platform: adc
    pin: GPIO2  # ADC-fähiger Pin
    name: "Shunt Spannung"
    unit_of_measurement: "V"
    accuracy_decimals: 3
    filters:
      - multiply: 0.001  # Umrechnung basierend auf Shunt-Widerstand
    # Strom = Spannung / Shunt-Widerstand
    # Leistung = Strom * Versorgungsspannung
```

**Hinweis:** Diese Methode erfordert eine präzise Kalibrierung und ist weniger genau als INA219.

## Empfehlung

### Für kontinuierliche Messung:
**INA219** ist die beste Option:
- Günstig (~2-5€)
- Gute Genauigkeit
- Einfache Integration
- Unterstützt durch ESPHome

### Für gelegentliche Messung:
**USB Power Monitor** ist am einfachsten:
- Keine Schaltungsänderung
- Sofort einsatzbereit
- Gute Genauigkeit

### Für Schätzung:
**Template-Sensor** basierend auf Betriebszustand:
- Keine zusätzliche Hardware
- Gute Näherungswerte
- Integration in HA möglich

## Implementierung in deiner Konfiguration

Falls du einen INA219 hinzufügen möchtest, benötigst du:
1. INA219 Modul
2. I2C-Verbindung (SDA/SCL)
3. Shunt-Widerstand (meist bereits auf Modul)
4. Anpassung der Stromversorgung (INA219 in Reihe)

Soll ich eine INA219-Konfiguration zu deiner `g13_led_stehlampe_ha.yaml` hinzufügen?

## Weitere Ressourcen

- [ESPHome INA219 Dokumentation](https://esphome.io/components/sensor/ina219.html)
- [INA219 Datenblatt](https://www.ti.com/lit/ds/symlink/ina219.pdf)
- [ESP32-C3 Power Consumption Guide](https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/api-guides/power-management.html)

