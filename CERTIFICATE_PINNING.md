# 🔒 Certificate Pinning - Zusätzliche Sicherheit

## 📋 Übersicht

Certificate Pinning ist eine Sicherheitstechnik, die zusätzlichen Schutz vor Man-in-the-Middle-Angriffen bietet, indem nur vertrauenswürdige Zertifikate akzeptiert werden.

## 🎯 Anwendungsbereiche

### 1. API-Kommunikation mit Home Assistant

**Status:** ✅ Nicht erforderlich (bereits geschützt)

Die API-Kommunikation zwischen ESP und Home Assistant verwendet bereits:
- **Noise Protocol Framework** mit 256-Bit Verschlüsselung
- **Verschlüsselte Verbindung** ohne TLS/HTTPS
- **Forward Secrecy** - Jede Session hat eigene Keys

**Certificate Pinning ist hier nicht anwendbar**, da kein TLS/HTTPS verwendet wird.

### 2. OTA-Updates

**Status:** ✅ Bereits geschützt (Passwort-Authentifizierung)

OTA-Updates sind bereits durch:
- **MD5-basierte Challenge-Response** Authentifizierung
- **Passwort-Schutz** verhindert unbefugte Updates

**Certificate Pinning könnte zusätzlich implementiert werden**, ist aber bei Passwort-Authentifizierung optional.

### 3. Externe HTTPS-Verbindungen

**Status:** ⚠️ Optional (falls `http_request` verwendet wird)

Falls das Gerät externe HTTPS-APIs aufruft (z.B. Wetter-API, Cloud-Services), kann Certificate Pinning implementiert werden.

## 🔧 Implementierung

### Certificate Pinning für externe HTTPS-Verbindungen

Falls du externe HTTPS-APIs aufrufst, kannst du Certificate Pinning wie folgt implementieren:

```yaml
# Beispiel: HTTP Request mit Certificate Pinning
http_request:
  useragent: "ESPHome/1.0"
  ssl_verification: true  # SSL-Verifizierung aktivieren
  
  # Certificate Pinning (SHA256 Fingerprint)
  # Ersetze mit dem Fingerprint deines Ziel-Servers
  # Fingerprint generieren: openssl s_client -connect example.com:443 < /dev/null 2>/dev/null | openssl x509 -fingerprint -sha256 -noout
  ssl_fingerprints:
    - "AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99"
```

### Certificate Fingerprint generieren

**Methode 1: OpenSSL**
```bash
openssl s_client -connect example.com:443 < /dev/null 2>/dev/null | \
  openssl x509 -fingerprint -sha256 -noout | \
  cut -d'=' -f2 | tr ':' ':' | tr '[:lower:]' '[:upper:]'
```

**Methode 2: Online-Tool**
- Verwende einen Online-SSL-Checker (z.B. SSL Labs)
- Kopiere den SHA256-Fingerprint

**Methode 3: Python**
```python
import ssl
import socket
import hashlib

hostname = 'example.com'
port = 443

context = ssl.create_default_context()
with socket.create_connection((hostname, port)) as sock:
    with context.wrap_socket(sock, server_hostname=hostname) as ssock:
        cert = ssock.getpeercert(binary_form=True)
        fingerprint = hashlib.sha256(cert).hexdigest()
        print(':'.join(fingerprint[i:i+2].upper() for i in range(0, len(fingerprint), 2)))
```

## 📝 Beispiel-Konfiguration

### HTTP Request mit Certificate Pinning

```yaml
# Beispiel: Wetter-API mit Certificate Pinning
http_request:
  useragent: "ESPHome/1.0"
  ssl_verification: true
  
  # Certificate Fingerprint des Ziel-Servers
  ssl_fingerprints:
    - "AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99"

# Beispiel: Sensor der externe API aufruft
sensor:
  - platform: http_request
    name: "Externe API Daten"
    url: "https://api.example.com/data"
    method: GET
    headers:
      Authorization: "Bearer !secret api_token"
    json_attributes_path: "$.data"
    update_interval: 60s
```

## ⚠️ Wichtige Hinweise

### Zertifikatsablauf

- **Problem:** SSL/TLS-Zertifikate haben eine begrenzte Gültigkeitsdauer
- **Lösung:** Bei Zertifikatserneuerung muss der Fingerprint aktualisiert werden
- **Empfehlung:** Verwende mehrere Fingerprints (z.B. aktuelles + nächstes Zertifikat)

### Mehrere Fingerprints

```yaml
ssl_fingerprints:
  - "AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99"  # Aktuelles Zertifikat
  - "11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00"  # Nächstes Zertifikat
```

### Root CA Certificate Bundle

Alternativ kannst du ein Root CA Certificate Bundle verwenden:

```yaml
http_request:
  ssl_verification: true
  # ESP-IDF verwendet automatisch Mozilla CA Bundle
  # Zusätzliche Root CAs können hinzugefügt werden
```

## 🔒 Sicherheitsbewertung

### Aktuelle Implementierung

| Komponente | Verschlüsselung | Certificate Pinning | Sicherheit |
|------------|----------------|---------------------|------------|
| **API (Home Assistant)** | Noise Protocol (AES-256-GCM) | Nicht erforderlich | ⭐⭐⭐⭐⭐ |
| **OTA Updates** | MD5 Challenge-Response | Optional | ⭐⭐⭐⭐ |
| **WiFi AP** | WPA2/WPA3 | Nicht anwendbar | ⭐⭐⭐⭐⭐ |
| **Externe HTTPS** | TLS/HTTPS | Optional (empfohlen) | ⭐⭐⭐⭐ |

### Empfehlung

- ✅ **API:** Bereits optimal geschützt (Noise Protocol)
- ✅ **OTA:** Passwort-Authentifizierung ausreichend
- ⚠️ **Externe HTTPS:** Certificate Pinning empfohlen (falls verwendet)

## 📚 Weitere Informationen

- [ESPHome HTTP Request Documentation](https://esphome.io/components/http_request.html)
- [ESP-IDF SSL/TLS Documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/protocols.html#ssl-tls)
- [Certificate Pinning Best Practices](https://owasp.org/www-community/controls/Certificate_and_Public_Key_Pinning)
- [ESP32 Certificate Pinning Examples](https://github.com/espressif/esp-idf/tree/master/examples/protocols/https_request)

---

**Autor:** MultiAnything - [@MultiAnything](https://github.com/MultiAnything)  
**Lizenz:** [ESPHome MIT License](https://github.com/esphome/esphome/blob/dev/LICENSE)

