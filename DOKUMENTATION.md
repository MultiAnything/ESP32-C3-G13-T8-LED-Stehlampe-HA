# G13 LED UltraSlim Stehlampe - ESPHome Konfiguration

## Übersicht

Diese Konfiguration ist für einen ESP32-C3 basierten Controller für eine G13 LED UltraSlim Stehlampe mit Home Assistant Integration.

## Hardware

- **Board:** ESP32-C3 DevKitM-1
- **Relais-Steuerung:** GPIO5 (über MOSFET-Schaltung)
- **Status LED:** GPIO8 (optional, Strapping-Pin - mit Vorsicht verwenden)

### Schaltplan

Die Hardware verwendet:
- ESP32-C3 Modul
- MOSFET (RML6344) zur Relais-Ansteuerung
- Relais (FINDER 13.61) für Lastschaltung
- Schutzdioden und Pull-Down Widerstände

## Features

✅ **Relais-Steuerung** - Ein/Aus-Schalter für G13 LED (GPIO5)  
✅ **ESP32 interne Temperatur** - Überwachung der Chip-Temperatur  
✅ **WiFi-Signalstärke** - Mit visueller Darstellung (grün/orange/rot)  
✅ **Zeit-Synchronisation** - Automatische Synchronisation mit Home Assistant  
✅ **Improv & Captive Portal** - WiFi-Provisionierung ohne statische Credentials  
✅ **Web-Server** - Status-Webinterface auf Port 80  
✅ **Diagnose-Sensoren** - Uptime, IP-Adresse, WiFi-Info, etc.

## Installation

### 1. In Home Assistant ESPHome-Erweiterung

1. Gehe zu: **Einstellungen → Geräte & Dienste → ESPHome**
2. Klicke auf **"Neue Konfiguration erstellen"** oder bearbeite eine bestehende
3. Aktiviere den **YAML-Modus**
4. Kopiere den Inhalt von `g13_led_stehlampe_ha.yaml` in die Konfiguration
5. Speichere die Konfiguration

### 2. WiFi-Provisionierung

Die Konfiguration unterstützt drei Methoden zur WiFi-Provisionierung:

**Option A: Improv Serial (USB)**
- Verbinde das ESP32-C3 Modul per USB
- Verwende die Improv-App oder ESPHome-Erweiterung zur Provisionierung

**Option B: Captive Portal**
- Das Gerät startet als Access Point "G13-LED-Stehlampe"
- Verbinde dich mit dem AP und öffne einen Browser
- Ein Captive Portal erscheint automatisch zur WiFi-Konfiguration

**Option C: Bluetooth LE Improv**
- ESP32-C3 unterstützt Bluetooth LE Improv
- Verwende die Improv-App auf deinem Smartphone

### 3. Kompilieren und Flashen

1. Klicke auf **"Installieren"** in der ESPHome-Erweiterung
2. Wähle **USB/Serial** für das erste Flashen
3. Wähle das entsprechende Gerät aus
4. Warte auf den Abschluss des Flash-Vorgangs

### 4. Nach dem ersten Upload

- Der API-Encryption-Key wird automatisch generiert
- Falls du später OTA-Updates mit Passwort möchtest, aktiviere die OTA-Konfiguration in der YAML
- Die Zeit wird automatisch mit Home Assistant synchronisiert

## Konfiguration

### GPIO Pinbelegung

| GPIO | Funktion | Beschreibung |
|------|----------|--------------|
| GPIO5 | Relais-Steuerung | Schaltet das Relais für die G13 LED |
| GPIO8 | Status LED | Optional, Strapping-Pin (mit Vorsicht verwenden) |

### WiFi-Signalstärke Bereiche

| Farbe | Bereich | Beschreibung |
|-------|---------|--------------|
| 🟢 Grün | > -50 dBm | Sehr gut |
| 🟠 Orange | -50 bis -70 dBm | Gut/Mittel |
| 🔴 Rot | < -70 dBm | Schlecht |
| Min/Max | -100 dBm bis -30 dBm | Möglicher Signalbereich |

### Entitäten in Home Assistant

Nach erfolgreichem Upload werden folgende Entitäten erstellt:

**Switches:**
- `switch.g13_led_relais` - Relais-Steuerung

**Sensoren:**
- `sensor.esp32_temperatur` - Interne ESP32 Temperatur (°C)
- `sensor.wifi_signal` - WiFi-Signalstärke (dBm)
- `sensor.uptime` - Betriebszeit

**Text-Sensoren:**
- `text_sensor.wifi_signalqualitat` - Signalqualität (Sehr gut/Gut/Mittel/Schlecht)
- `text_sensor.wifi_signal_status` - Status für Farbanzeige (grün/orange/rot)
- `text_sensor.ip_adresse` - IP-Adresse
- `text_sensor.wifi_ssid` - WiFi SSID
- `text_sensor.mac_adresse` - MAC-Adresse
- `text_sensor.esphome_version` - ESPHome Version

**Binary Sensoren:**
- `binary_sensor.status` - Gerätestatus

## Home Assistant Karten-Konfiguration

Siehe `home_assistant_card_wifi.yaml` für Beispiel-Kartenkonfigurationen zur visuellen Darstellung des WiFi-Signals.

## Troubleshooting

### Kompilierungsfehler: CMake Compiler nicht gefunden

**Problem:** ESPHome 2025.10.x integriert Arduino als ESP-IDF-Komponente, was zu CMake-Fehlern führen kann.

**Lösung:** 
- Die Konfiguration verwendet jetzt explizit `framework: type: esp-idf` mit Version 5.4.2
- Falls weiterhin Probleme auftreten:
  1. Bereinige die Build-Dateien in HA ESPHome-Erweiterung (drei Punkte → Bereinigen)
  2. Oder versuche eine ältere ESPHome-Version
  3. Oder verwende `framework: type: arduino` ohne Version (ESPHome wählt automatisch)

### GPIO8 Strapping-Pin Warnung

**Problem:** GPIO8 ist ein Strapping-Pin und sollte mit Vorsicht verwendet werden.

**Lösung:**
- Falls Probleme auftreten, verwende einen anderen Pin für die Status-LED
- Oder entferne die Status-LED-Konfiguration komplett

### OTA-Update funktioniert nicht

**Problem:** ESPHome 2025.10.4 unterstützt die `esphome` OTA-Plattform möglicherweise nicht.

**Lösung:**
- OTA ist in der Konfiguration vorübergehend deaktiviert
- Verwende USB/Serial für Updates
- Oder aktualisiere ESPHome auf eine neuere Version

### WiFi-Verbindungsprobleme

**Problem:** Gerät verbindet sich nicht mit WiFi.

**Lösung:**
1. Prüfe, ob der Fallback-AP "G13-LED-Stehlampe" verfügbar ist
2. Verwende das Captive Portal zur erneuten WiFi-Konfiguration
3. Prüfe die WiFi-Signalstärke in Home Assistant

### Zeit-Synchronisation

Die Zeit wird automatisch beim Booten mit Home Assistant synchronisiert. Falls die Zeit nicht korrekt ist:
- Prüfe die Home Assistant Systemzeit
- Stelle sicher, dass die API-Verbindung funktioniert
- Prüfe die Logs in ESPHome

## Erweiterte Konfiguration

### OTA-Updates aktivieren

Falls du OTA-Updates mit Passwort aktivieren möchtest:

1. Füge in `secrets.yaml` hinzu:
   ```yaml
   ota_password: "dein_sicheres_passwort"
   ```

2. Aktiviere in der YAML-Konfiguration:
   ```yaml
   ota:
     - platform: esphome
       password: !secret ota_password
       safe_mode: true
       port: 3232
   ```

### Statische WiFi-Credentials

Falls du statische WiFi-Credentials verwenden möchtest:

1. Füge in `secrets.yaml` hinzu:
   ```yaml
   wifi_ssid: "DEIN_WIFI_SSID"
   wifi_password: "DEIN_WIFI_PASSWORT"
   ```

2. Aktiviere in der YAML-Konfiguration:
   ```yaml
   wifi:
     ssid: !secret wifi_ssid
     password: !secret wifi_password
     fast_connect: true
   ```

### API-Encryption-Key

Der API-Encryption-Key wird beim ersten Upload automatisch generiert. Falls du ihn manuell setzen möchtest:

1. Generiere einen Key:
   ```bash
   python3 -c "import secrets; print(secrets.token_hex(32))"
   ```

2. Füge in `secrets.yaml` hinzu:
   ```yaml
   api_encryption_key: "dein_generierter_key_hier"
   ```

3. Aktiviere in der YAML-Konfiguration:
   ```yaml
   api:
     encryption:
       key: !secret api_encryption_key
   ```

## Dateien

- `g13_led_stehlampe_ha.yaml` - Hauptkonfiguration für Home Assistant ESPHome-Erweiterung
- `g13_led_stehlampe.yaml` - Alternative Konfiguration für lokale ESPHome-Nutzung
- `home_assistant_card_wifi.yaml` - Beispiel-Kartenkonfigurationen für HA
- `secrets.yaml.example` - Vorlage für Secrets

## Version

- **ESPHome Version:** 2025.10.4
- **Board:** ESP32-C3 DevKitM-1
- **Framework:** Arduino
- **Letzte Aktualisierung:** 2025

## Support

Bei Problemen:
1. Prüfe die ESPHome-Logs in Home Assistant
2. Prüfe die Serial-Ausgabe beim Booten
3. Siehe ESPHome-Dokumentation: https://esphome.io/


