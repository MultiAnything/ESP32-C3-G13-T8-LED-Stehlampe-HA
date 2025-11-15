# CMake Compiler Fehler - Troubleshooting

## Problem

ESPHome 2025.10.x versucht ESP-IDF zu verwenden, auch wenn Arduino konfiguriert ist. Die ESP-IDF-Toolchain ist in der HA-Installation möglicherweise nicht vollständig.

## Lösungen

### Lösung 1: ESPHome Add-on aktualisieren/neu installieren

1. Gehe zu: **Einstellungen → Add-ons → ESPHome**
2. Stoppe das Add-on
3. Aktualisiere auf die neueste Version
4. Starte das Add-on neu
5. Versuche erneut zu kompilieren

### Lösung 2: Build-Cache bereinigen

1. In ESPHome-Erweiterung: Drei Punkte (⋮) → **"Bereinigen"**
2. Warte, bis der Bereinigungsvorgang abgeschlossen ist
3. Versuche erneut zu kompilieren

### Lösung 3: ESPHome auf ältere Version zurücksetzen

Falls die neueste Version Probleme verursacht:

1. Gehe zu: **Einstellungen → Add-ons → ESPHome**
2. Klicke auf **"Version"**
3. Wähle eine ältere, stabile Version (z.B. 2024.x)
4. Installiere die Version
5. Versuche erneut zu kompilieren

### Lösung 4: ESPHome Add-on neu installieren

**WICHTIG:** Erstelle vorher ein Backup deiner Konfigurationen!

1. Gehe zu: **Einstellungen → Add-ons → ESPHome**
2. Stoppe das Add-on
3. Deinstalliere das Add-on
4. Installiere ESPHome erneut
5. Stelle deine Konfigurationen wieder her
6. Versuche erneut zu kompilieren

### Lösung 5: Manuelle PlatformIO-Toolchain Installation

Falls du Zugriff auf das HA-Terminal hast:

```bash
# Im ESPHome Add-on Terminal
cd /data
rm -rf .platformio
# ESPHome wird die Toolchain beim nächsten Kompilieren neu herunterladen
```

### Lösung 6: Alternative Board-Konfiguration

Versuche eine alternative Board-Konfiguration:

```yaml
esp32:
  board: esp32-c3-devkitm-1
  framework:
    type: arduino
    # Keine Version - ESPHome wählt automatisch
```

### Lösung 7: ESPHome über Docker/CLI verwenden

Falls die HA-Erweiterung weiterhin Probleme macht, kannst du ESPHome lokal installieren:

```bash
pip install esphome
esphome compile g13_led_stehlampe_ha.yaml
esphome upload g13_led_stehlampe_ha.yaml --device /dev/ttyUSB0
```

## Bekannte Probleme

- **ESPHome 2025.10.x:** Integriert Arduino als ESP-IDF-Komponente, was zu Toolchain-Problemen führen kann
- **ESP-IDF Toolchain:** Wird möglicherweise nicht vollständig in HA installiert
- **PlatformIO Cache:** Kann korrupt sein und muss bereinigt werden

## Empfohlene Reihenfolge

1. **Zuerst:** Build-Cache bereinigen (Lösung 2)
2. **Dann:** ESPHome Add-on aktualisieren (Lösung 1)
3. **Falls weiterhin Probleme:** ESPHome auf ältere Version zurücksetzen (Lösung 3)
4. **Als letzter Ausweg:** ESPHome neu installieren (Lösung 4)

## Weitere Hilfe

- ESPHome Community: https://community.home-assistant.io/c/esphome/
- ESPHome Dokumentation: https://esphome.io/
- ESPHome GitHub Issues: https://github.com/esphome/esphome/issues

