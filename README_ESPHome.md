# ESPHome Konfiguration für G13 LED UltraSlim Stehlampe

## Installation

### 1. ESPHome installieren

```bash
pip install esphome
```

### 2. Secrets-Datei erstellen

Kopiere `secrets.yaml.example` zu `secrets.yaml` und fülle die Werte aus:

```bash
cp secrets.yaml.example secrets.yaml
nano secrets.yaml
```

### 3. API-Verschlüsselungsschlüssel generieren

```bash
esphome secrets generate-key
```

Füge den generierten Schlüssel in `secrets.yaml` unter `api_encryption_key` ein.

### 4. Kompilieren und Hochladen

```bash
# Kompilieren
esphome compile led_t8_controller.yaml

# Über USB hochladen (erstes Mal)
esphome upload led_t8_controller.yaml --device /dev/ttyUSB0

# OTA Update (später)
esphome upload led_t8_controller.yaml
```

## Features

✅ **ESP32-C3 Support** - Optimiert für ESP32-C3 DevKitM-1  
✅ **OTA Updates** - Drahtlose Updates mit Passwortschutz  
✅ **Home Assistant Integration** - Vollständige API-Integration  
✅ **Relais-Steuerung** - Einfacher Ein/Aus-Schalter für G13 LED  
✅ **Web Server** - Status-Webinterface auf Port 80  
✅ **WiFi Fallback** - Access Point bei Verbindungsproblemen  
✅ **Diagnostik** - WiFi-Signal, Uptime, IP-Adresse  

## GPIO Pinbelegung

- **GPIO5**: Relais-Steuerung (Ein/Aus für G13 LED)
- **GPIO8**: Status LED (optional)

## Anpassungen

### Invertiertes Relais

Falls dein Relais invertiert arbeitet (LOW = EIN, HIGH = AUS), ändere in `led_t8_controller.yaml`:
```yaml
switch:
  - platform: gpio
    pin: GPIO5
    inverted: true  # Auf true ändern
```

### Andere GPIO Pins

Passe die Pin-Nummer in der `switch:` Sektion an deine Hardware an.

### Home Assistant Discovery

Das Gerät wird automatisch in Home Assistant erkannt, wenn ESPHome-Integration aktiviert ist.

## Troubleshooting

### Gerät nicht erreichbar

1. Prüfe WiFi-Verbindung
2. Prüfe ob Fallback-AP verfügbar ist
3. Prüfe Serial Monitor: `esphome logs led_t8_controller.yaml`

### OTA Update schlägt fehl

1. Prüfe OTA-Passwort in `secrets.yaml`
2. Stelle sicher, dass Gerät im gleichen Netzwerk ist
3. Prüfe Firewall-Einstellungen

## Erweiterte Konfiguration

Siehe [ESPHome Dokumentation](https://esphome.io/) für weitere Optionen.

