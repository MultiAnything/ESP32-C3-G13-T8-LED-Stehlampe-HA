# Lokale ESPHome Installation und Kompilierung

## Warum lokal kompilieren?

- **Mehr Speicher:** Lokale Systeme haben meist mehr RAM verfügbar
- **Schneller:** Keine Container-Limitierungen
- **Kontrolle:** Volle Kontrolle über die Build-Umgebung
- **Debugging:** Bessere Fehlerbehandlung

## Voraussetzungen

### 1. Python 3.8 oder höher

Prüfe deine Python-Version:
```bash
python3 --version
```

Falls nicht installiert:
- **Linux (Debian/Ubuntu):**
  ```bash
  sudo apt update
  sudo apt install python3 python3-pip python3-venv
  ```

- **macOS:**
  ```bash
  brew install python3
  ```

- **Windows:**
  - Lade Python von https://www.python.org/downloads/
  - Stelle sicher, dass "Add Python to PATH" aktiviert ist

### 2. pip (Python Package Manager)

Normalerweise mit Python installiert. Prüfe:
```bash
pip3 --version
```

Falls nicht vorhanden:
```bash
python3 -m ensurepip --upgrade
```

### 3. USB-Zugriff (für Flashen)

**Linux:**
```bash
# Prüfe ob dein Benutzer in der dialout Gruppe ist
groups

# Falls nicht, füge dich hinzu:
sudo usermod -a -G dialout $USER
# Logge dich aus und wieder ein, damit die Änderung wirksam wird
```

**macOS:**
- Keine zusätzlichen Schritte nötig

**Windows:**
- Installiere USB-Treiber für dein ESP32-Board (z.B. CP2102 oder CH340 Treiber)

## Installation

### Schritt 1: Virtuelle Umgebung erstellen (empfohlen)

```bash
# Navigiere zu deinem Projekt-Verzeichnis
cd "/home/sam/Dokumente/PlatformIO/Projects/ESP32-C3 G13_LED_UltraSlim Stehlampe-HA"

# Erstelle virtuelle Umgebung
python3 -m venv esphome-env

# Aktiviere virtuelle Umgebung
# Linux/macOS:
source esphome-env/bin/activate

# Windows:
# esphome-env\Scripts\activate
```

### Schritt 2: ESPHome installieren

```bash
# Aktualisiere pip
pip install --upgrade pip

# Installiere ESPHome
pip install esphome

# Prüfe Installation
esphome version
```

### Schritt 3: Secrets-Datei erstellen (optional)

Falls du Secrets verwendest:

```bash
# Kopiere die Beispiel-Datei
cp secrets.yaml.example secrets.yaml

# Bearbeite secrets.yaml und füge deine Werte ein
nano secrets.yaml
```

## Kompilierung

### Schritt 1: Konfiguration validieren

```bash
# Validiere die Konfiguration (ohne zu kompilieren)
esphome config g13_led_stehlampe_ha.yaml
```

### Schritt 2: Kompilieren

```bash
# Kompiliere die Firmware
esphome compile g13_led_stehlampe_ha.yaml
```

### Schritt 3: Firmware flashen

**Option A: USB/Serial (erstes Mal)**
```bash
# Liste verfügbare Geräte
esphome upload g13_led_stehlampe_ha.yaml --device /dev/ttyUSB0

# Oder automatisch Gerät finden lassen
esphome upload g13_led_stehlampe_ha.yaml
```

**Option B: OTA (nach erstem Flash)**
```bash
esphome upload g13_led_stehlampe_ha.yaml
```

## Nützliche Befehle

### Logs anzeigen
```bash
esphome logs g13_led_stehlampe_ha.yaml
```

### Build-Cache bereinigen
```bash
esphome clean g13_led_stehlampe_ha.yaml
```

### Nur kompilieren (ohne zu flashen)
```bash
esphome compile g13_led_stehlampe_ha.yaml
```

### Firmware-Datei finden
Nach erfolgreicher Kompilierung findest du die Firmware hier:
```
.pioenvs/g13-led-ultraslim-stehlampe/firmware.bin
```

## Troubleshooting

### Problem: "Permission denied" bei USB-Gerät

**Linux:**
```bash
# Füge dich zur dialout Gruppe hinzu
sudo usermod -a -G dialout $USER
# Logge dich aus und wieder ein
```

**Temporäre Lösung:**
```bash
sudo esphome upload g13_led_stehlampe_ha.yaml --device /dev/ttyUSB0
```

### Problem: "Device not found"

**Linux:**
```bash
# Prüfe verfügbare USB-Geräte
ls -la /dev/ttyUSB* /dev/ttyACM*

# Oder mit dmesg
dmesg | tail
```

**macOS:**
```bash
ls /dev/cu.*
```

**Windows:**
- Prüfe Geräte-Manager → COM-Ports

### Problem: "Module not found"

```bash
# Stelle sicher, dass die virtuelle Umgebung aktiviert ist
source esphome-env/bin/activate

# Installiere ESPHome erneut
pip install --upgrade esphome
```

### Problem: Kompilierungsfehler

```bash
# Bereinige Build-Cache
esphome clean g13_led_stehlampe_ha.yaml

# Versuche erneut
esphome compile g13_led_stehlampe_ha.yaml
```

## Automatisierung

### Script für einfache Nutzung

Erstelle eine Datei `build.sh`:

```bash
#!/bin/bash
cd "$(dirname "$0")"
source esphome-env/bin/activate
esphome compile g13_led_stehlampe_ha.yaml
```

Ausführbar machen:
```bash
chmod +x build.sh
```

Verwenden:
```bash
./build.sh
```

## Vergleich: HA vs. Lokal

| Feature | Home Assistant | Lokal |
|---------|----------------|-------|
| Speicher | Begrenzt (Container) | Vollständig verfügbar |
| Geschwindigkeit | Langsamer | Schneller |
| Einrichtung | Einfach | Etwas komplexer |
| Updates | Automatisch | Manuell |
| Debugging | Begrenzt | Vollständig |

## Nächste Schritte

1. **Installiere ESPHome lokal** (siehe oben)
2. **Kompiliere die Konfiguration** lokal
3. **Flashe die Firmware** auf das Gerät
4. **Nach erfolgreichem Flash:** Du kannst wieder HA ESPHome-Erweiterung für OTA-Updates verwenden

## Tipp

Nach dem ersten erfolgreichen Flash über USB kannst du:
- OTA-Updates in HA ESPHome-Erweiterung aktivieren
- Weitere Updates über HA durchführen (benötigt weniger Speicher)
- Lokale Installation für größere Änderungen verwenden

## Weitere Ressourcen

- ESPHome Dokumentation: https://esphome.io/
- ESPHome Installation: https://esphome.io/guides/getting_started_command_line.html
- ESPHome CLI Referenz: https://esphome.io/guides/command-line.html

