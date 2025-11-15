# 💡 Stehlampe UltraSlim - Smart Home Controller

ESP32-C3 basierter Smart Home Controller für G13 LED-Leuchtmittel mit vollständiger Home Assistant Integration.

## 🚀 Features

- ✅ **Smart Relais-Steuerung** - Ein/Aus-Schaltung für G13 LED (18W)
- ✅ **Dual-Temperatur-Monitoring** - Interne CPU + Externe Umgebungstemperatur (DS18B20)
- ✅ **WiFi-Intelligenz** - Signalstärke-Monitoring mit visueller Statusanzeige
- ✅ **Energie-Monitoring** - Echtzeit-Leistungsmessung und täglicher Verbrauch
- ✅ **Enterprise-Level Sicherheit** - 256-Bit Verschlüsselung (Noise Protocol Framework)
- ✅ **Over-The-Air Updates** - Drahtlose Firmware-Updates mit Passwortschutz
- ✅ **Home Assistant Integration** - Vollständige API-Integration mit Verschlüsselung
- ✅ **Zeit-Synchronisation** - Automatische RTC-Synchronisation mit Home Assistant
- ✅ **Umfassende Diagnostik** - Uptime, IP-Adresse, WiFi-Info, Status-Monitoring

## 📋 Hardware

- **Mikrocontroller:** ESP32-C3 DevKitM-1 (RISC-V, 160 MHz)
- **RAM:** 320 KB
- **Flash:** 4 MB
- **GPIO Pins:**
  - GPIO5: Relais-Steuerung (G13 LED)
  - GPIO4: DS18B20/DS18S20 Temperatursensor (One-Wire)
  - GPIO8: Onboard LED (ungenutzt)

## 🔧 Installation

### 1. Repository klonen

```bash
git clone <repository-url>
cd "ESP32-C3 G13_LED_UltraSlim Stehlampe-HA"
```

### 2. Secrets konfigurieren

```bash
cp secrets.yaml.example secrets.yaml
nano secrets.yaml  # Oder deinen bevorzugten Editor verwenden
```

Fülle die folgenden Werte in `secrets.yaml` aus:
- `wifi_ssid`: Dein WiFi-Netzwerkname
- `wifi_password`: Dein WiFi-Passwort
- `ota_password`: Starkes Passwort für OTA-Updates (min. 16 Zeichen)
- `ap_password`: Passwort für Fallback-Access-Point (min. 16 Zeichen)
- `api_encryption_key`: Base64-kodierter 32-Byte Key (256 Bit)

**API-Key generieren:**
```bash
python3 -c "import secrets; import base64; print(base64.b64encode(secrets.token_bytes(32)).decode())"
```

### 3. ESPHome installieren

**Option A: Lokale Installation (empfohlen für größere Projekte)**

```bash
./install_esphome.sh
source esphome-env/bin/activate
```

**Option B: Home Assistant ESPHome Add-on**

1. Gehe zu: **Einstellungen → Add-ons → ESPHome**
2. Installiere die ESPHome-Erweiterung
3. Öffne die Web-UI

### 4. Firmware kompilieren und flashen

**Lokal:**
```bash
source esphome-env/bin/activate
esphome compile g13_led_stehlampe_ha.yaml
esphome upload g13_led_stehlampe_ha.yaml --device /dev/ttyUSB0  # Erstes Mal über USB
```

**Home Assistant:**
1. Öffne ESPHome-Erweiterung
2. Klicke auf "Neue Konfiguration erstellen"
3. Kopiere den Inhalt von `g13_led_stehlampe_ha.yaml`
4. Klicke auf "INSTALL"

### 5. Home Assistant Integration

Das Gerät wird automatisch in Home Assistant erkannt, wenn:
- ESPHome-Integration aktiviert ist
- Gerät und Home Assistant im gleichen Netzwerk sind
- API-Verschlüsselung korrekt konfiguriert ist

## 📁 Projektstruktur

```
.
├── g13_led_stehlampe_ha.yaml      # Hauptkonfiguration (für HA ESPHome)
├── g13_led_stehlampe.yaml          # Alternative Konfiguration (lokal)
├── secrets.yaml.example            # Vorlage für Secrets (KEINE echten Werte!)
├── .gitignore                      # Git-Ignore (schützt secrets.yaml)
├── README.md                       # Diese Datei
├── PRODUKTUEBERSICHT.md            # Detaillierte Produktübersicht
├── SICHERHEITSANALYSE.md           # Sicherheitsanalyse
├── ENERGIEANALYSE.md               # Energieverbrauchsanalyse
├── install_esphome.sh              # ESPHome Installations-Script
├── build.sh                        # Build & Flash Script
└── docs/                           # Weitere Dokumentation
```

## 🔒 Sicherheit

### Implementierte Sicherheitsmaßnahmen

- ✅ **256-Bit API-Verschlüsselung** - Noise Protocol Framework
- ✅ **OTA-Passwortschutz** - MD5 Challenge-Response
- ✅ **Geschützter Access Point** - WPA2/WPA3 Verschlüsselung
- ✅ **Forward Secrecy** - Jede Session hat eigene Keys
- ✅ **Bluetooth deaktiviert** - Reduzierte Angriffsfläche

### Sicherheitsbewertung: ⭐⭐⭐⭐⭐ (5/5)

Siehe `SICHERHEITSANALYSE.md` für Details.

## ⚡ Energieeffizienz

- **Standby:** 0,20W (43% Reduktion gegenüber Standard)
- **Betrieb:** 18,20W (Lampe + Controller)
- **ESP32-C3 SuperMini CPU Temperatur:** 
  - **Dokumentiert:** 50,6°C (20°C niedriger als Standard)
  - **Gemessen (Standby):** 43,9°C (26-27°C niedriger als Standard)
  - **Typischer Bereich:** 44-51°C (je nach Last und Umgebungstemperatur)

**⚠️ Disclaimer:** Alle Angaben ohne Gewähr. Die Werte basieren auf Messungen unter spezifischen Bedingungen und können je nach Umgebung, Hardware-Variationen und Konfiguration abweichen.

Siehe `ENERGIEANALYSE.md` für Details.

## 📊 Home Assistant Entitäten

### Switches
- `switch.g13_led_relais` - Hauptschalter
- `switch.neustart` - Geräte-Neustart
- `switch.safe_mode` - Sicherheitsmodus

### Sensoren
- `sensor.internal_temp` - CPU-Temperatur
- `sensor.external_temp` - Umgebungstemperatur
- `sensor.wifi_signal` - WiFi-Signalstärke (dBm)
- `sensor.energieverbrauch_leistung` - Aktuelle Leistung (W)
- `sensor.energieverbrauch_taglich` - Täglicher Verbrauch (kWh)
- `sensor.uptime` - Betriebszeit

### Text Sensoren
- `text_sensor.ip_adresse` - IP-Adresse
- `text_sensor.wifi_ssid` - Verbundenes Netzwerk
- `text_sensor.mac_adresse` - Geräte-Identifikation
- `text_sensor.esphome_version` - Firmware-Version
- `text_sensor.wifi_signalqualitat` - Qualitätsbewertung
- `text_sensor.wifi_signal_status` - Farbstatus (grün/orange/rot)

### Binary Sensoren
- `binary_sensor.status` - Online/Offline-Status

## 🔄 Updates

### Over-The-Air (OTA)

```bash
esphome upload g13_led_stehlampe_ha.yaml --device g13-led-ultraslim-stehlampe.local
```

Das OTA-Passwort wird automatisch aus `secrets.yaml` verwendet.

## 📚 Dokumentation

- **PRODUKTUEBERSICHT.md** - Vollständige Produktübersicht mit allen Features
- **SICHERHEITSANALYSE.md** - Detaillierte Sicherheitsbewertung
- **ENERGIEANALYSE.md** - Energieverbrauchsanalyse
- **OTA_ERKLAERUNG.md** - Wie OTA funktioniert
- **VERSCHLUESSELUNG.md** - Verschlüsselungsdetails
- **DOKUMENTATION.md** - Technische Dokumentation

## 🛠️ Entwicklung

### Lokale Entwicklungsumgebung

```bash
# ESPHome installieren
./install_esphome.sh

# Virtual Environment aktivieren
source esphome-env/bin/activate

# Kompilieren
esphome compile g13_led_stehlampe_ha.yaml

# Flashen (USB)
esphome upload g13_led_stehlampe_ha.yaml --device /dev/ttyUSB0

# Flashen (OTA)
esphome upload g13_led_stehlampe_ha.yaml --device g13-led-ultraslim-stehlampe.local

# Logs anzeigen
esphome logs g13_led_stehlampe_ha.yaml
```

## ⚠️ Wichtige Hinweise

### Secrets-Datei

- **NIEMALS** `secrets.yaml` in Git committen!
- Verwende `secrets.yaml.example` als Vorlage
- `secrets.yaml` ist bereits in `.gitignore` eingetragen

### Sicherheit

- Verwende **starke, eindeutige Passwörter** für jedes Gerät
- Rotiere Passwörter regelmäßig (alle 6-12 Monate)
- Speichere `secrets.yaml` sicher (verschlüsseltes Backup)

### GPIO8 Warnung

GPIO8 ist ein Strapping-Pin. Die Onboard-LED wird ignoriert (kein Output-Pin), um Energie zu sparen.

## 🐛 Troubleshooting

Siehe `DOKUMENTATION.md` für häufige Probleme und Lösungen.

## 📄 Lizenz

Dieses Projekt basiert auf **ESPHome** und verwendet die gleiche Lizenz.

**ESPHome Lizenz:** [MIT License](https://github.com/esphome/esphome/blob/dev/LICENSE)

Die vollständigen Lizenzbedingungen von ESPHome finden Sie unter:
https://github.com/esphome/esphome/blob/dev/LICENSE

## 👤 Autor

**MultiAnything** - [@MultiAnything](https://github.com/MultiAnything)

## 🙏 Danksagungen

- ESPHome Community
- Home Assistant Team
- Espressif Systems (ESP32-C3)

---

**Version:** 1.0  
**Firmware:** ESPHome 2025.5.2  
**Hardware:** ESP32-C3 DevKitM-1
