# API-Encryption-Key Generierung

## Option 1: Automatisch (Empfohlen)

Die Konfiguration ist so eingestellt, dass ESPHome den API-Key beim ersten Upload automatisch generiert. Nach dem ersten Upload findest du den generierten Key in der `secrets.yaml` Datei in Home Assistant.

**Schritte:**
1. Lade die Konfiguration das erste Mal hoch (ohne encryption-Zeile)
2. ESPHome generiert automatisch einen Key
3. Der Key wird in `/config/esphome/secrets.yaml` gespeichert
4. Danach kannst du die encryption-Zeile wieder aktivieren

## Option 2: Manuell mit Python

Falls Python installiert ist, kannst du den Key so generieren:

```bash
python3 -c "import secrets; print(secrets.token_hex(32))"
```

Oder mit OpenSSL:
```bash
openssl rand -hex 32
```

## Option 3: Online-Tool

Du kannst auch ein Online-Tool verwenden, um einen zufälligen Hex-String zu generieren:
- https://www.random.org/strings/
- Länge: 64 Zeichen (32 Bytes in Hex)

## Option 4: In Home Assistant ESPHome-Erweiterung

1. Gehe zu: **Einstellungen → Add-ons → ESPHome**
2. Öffne das Terminal
3. Führe aus:
```bash
esphome secrets generate-key
```

## Nach der Generierung

Füge den generierten Key in deine `secrets.yaml` ein:

```yaml
api_encryption_key: "dein_generierter_key_hier_64_zeichen_hex"
```

Dann aktiviere die encryption-Zeile in der YAML-Datei wieder:
```yaml
api:
  encryption:
    key: !secret api_encryption_key
  reboot_timeout: 15min
```

