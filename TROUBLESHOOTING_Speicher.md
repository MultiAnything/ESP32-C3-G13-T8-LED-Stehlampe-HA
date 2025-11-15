# Speicherprobleme beim Kompilieren - Troubleshooting

## Problem: "Killed signal terminated program cc1plus"

Dieser Fehler tritt auf, wenn während der Kompilierung der Speicher ausgeht. Das ist ein häufiges Problem bei ESPHome-Kompilierungen in Home Assistant, besonders wenn das System wenig RAM hat.

## Sofortlösung: Features deaktivieren

Die Konfiguration wurde optimiert, um den Speicherbedarf beim Kompilieren zu reduzieren:

### Vorübergehend deaktiviert:
- ✅ **Web-Server** - Kann nach erfolgreicher Kompilierung wieder aktiviert werden
- ✅ **Captive Portal** - Kann nach erfolgreicher Kompilierung wieder aktiviert werden  
- ✅ **Interval-Logger** - Kann nach erfolgreicher Kompilierung wieder aktiviert werden

### Aktiv bleiben:
- ✅ Relais-Steuerung
- ✅ ESP32 Temperatur
- ✅ WiFi-Signalstärke
- ✅ Zeit-Synchronisation
- ✅ Improv Serial & Bluetooth LE
- ✅ Alle Sensoren

## Nach erfolgreicher Kompilierung

Sobald die Firmware erfolgreich kompiliert und geflasht wurde, kannst du die deaktivierten Features wieder aktivieren:

### 1. Web-Server aktivieren

```yaml
# Web Server für Status
web_server:
  port: 80
  version: 2
  include_internal: true
```

### 2. Captive Portal aktivieren

```yaml
# Captive Portal für WiFi-Provisionierung
captive_portal:
```

### 3. Interval-Logger aktivieren

```yaml
# Interne Komponenten
interval:
  - interval: 30s
    then:
      - logger.log: "G13 LED Stehlampe läuft"
```

**Wichtig:** Aktiviere diese Features einzeln und kompiliere nach jeder Änderung, um zu sehen, ob genug Speicher vorhanden ist.

## Weitere Lösungen

### Lösung 1: HA-System-Speicher erhöhen

Falls möglich, erhöhe den verfügbaren Speicher für Home Assistant:
- Stoppe andere Add-ons während der Kompilierung
- Erhöhe den verfügbaren RAM für HA (falls in VM/Docker)

### Lösung 2: ESPHome lokal kompilieren

Falls die HA-Installation weiterhin Probleme macht, kompiliere lokal:

```bash
# ESPHome installieren
pip install esphome

# Kompilieren
esphome compile g13_led_stehlampe_ha.yaml

# Flashen
esphome upload g13_led_stehlampe_ha.yaml --device /dev/ttyUSB0
```

### Lösung 3: Build-Cache bereinigen

Manchmal hilft es, den Build-Cache zu bereinigen:

1. In ESPHome-Erweiterung: Drei Punkte (⋮) → **"Bereinigen"**
2. Warte, bis der Bereinigungsvorgang abgeschlossen ist
3. Versuche erneut zu kompilieren

### Lösung 4: ESPHome Add-on neu starten

1. Stoppe das ESPHome Add-on
2. Warte 30 Sekunden
3. Starte das Add-on neu
4. Versuche erneut zu kompilieren

### Lösung 5: Minimale Konfiguration testen

Erstelle eine minimale Test-Konfiguration, um zu prüfen, ob das Problem an der Konfiguration liegt:

```yaml
esphome:
  name: test
  platform: ESP32
  board: esp32-c3-devkitm-1

esp32:
  framework:
    type: arduino

wifi:
  ap:
    ssid: "Test"

api:
```

Falls diese minimale Konfiguration kompiliert, liegt das Problem an der Größe der vollständigen Konfiguration.

## Warum passiert das?

- **ESP32-C3 Kompilierung:** Benötigt viel Speicher für die Toolchain
- **ESPHome Features:** Jedes Feature erhöht den Speicherbedarf
- **HA-Add-on:** Läuft in einem Container mit begrenztem Speicher
- **Parallele Kompilierung:** Mehrere Dateien werden gleichzeitig kompiliert

## Empfohlene Reihenfolge

1. **Zuerst:** Versuche mit der optimierten Konfiguration (Features deaktiviert)
2. **Dann:** Nach erfolgreichem Flash, aktiviere Features einzeln
3. **Falls weiterhin Probleme:** Verwende lokale ESPHome-Installation
4. **Als letzter Ausweg:** Erhöhe den verfügbaren Speicher für HA

## Erfolgreiche Kompilierung

Sobald die Kompilierung erfolgreich ist, kannst du:
- Die Firmware auf das Gerät flashen
- Die deaktivierten Features schrittweise wieder aktivieren
- OTA-Updates verwenden (falls aktiviert)

Die minimale Konfiguration sollte ausreichen, um das Gerät zum Laufen zu bringen. Die zusätzlichen Features können später hinzugefügt werden.

