# Sicherheitsanalyse: G13 LED Stehlampe ESPHome

## 🔴 Aktuelle Sicherheitsprobleme

### 1. **API-Verschlüsselung deaktiviert** ⚠️ KRITISCH
```yaml
# encryption:
#   key: !secret api_encryption_key
```
**Problem:** Die Kommunikation zwischen ESP und Home Assistant ist unverschlüsselt.
**Risiko:** Angreifer können:
- Sensordaten abfangen
- Befehle an das Gerät senden
- Den Status manipulieren

### 2. **OTA-Updates ohne Passwort** ⚠️ HOCH
```yaml
# password: !secret ota_password
```
**Problem:** Jeder im Netzwerk kann Firmware hochladen.
**Risiko:** 
- Malware-Installation
- Gerätübernahme
- Backdoor-Installation

### 3. **Access Point ohne Passwort** ⚠️ MITTEL
```yaml
ap:
  ssid: "G13-LED-Stehlampe"
  # password: !secret ap_password
```
**Problem:** Offenes WLAN bei Verbindungsproblemen.
**Risiko:**
- Unbefugter Zugriff
- Man-in-the-Middle-Angriffe
- WiFi-Credential-Diebstahl

### 4. **ESP32 Improv ohne Authentifizierung** ⚠️ MITTEL
```yaml
esp32_improv:
  authorizer: none
```
**Problem:** Bluetooth-Provisionierung ohne Authentifizierung.
**Risiko:**
- Unbefugte WiFi-Konfiguration
- Gerätübernahme über Bluetooth

### 5. **Web Server deaktiviert (aber ungeschützt wenn aktiv)**
**Problem:** Falls aktiviert, kein Passwortschutz konfiguriert.
**Risiko:** Unbefugter Zugriff auf Status-Informationen

---

## ✅ Empfohlene Sicherheitsmaßnahmen

### Priorität 1: KRITISCH - Sofort umsetzen

#### 1. API-Verschlüsselung aktivieren

**Schritt 1:** API-Key generieren (falls noch nicht geschehen)
```bash
# In HA ESPHome Terminal:
esphome secrets generate-key

# Oder lokal:
python3 -c "import secrets; print(secrets.token_hex(32))"
```

**Schritt 2:** Key in `secrets.yaml` eintragen:
```yaml
api_encryption_key: "dein_64_zeichen_hex_key_hier"
```

**Schritt 3:** In `g13_led_stehlampe_ha.yaml` aktivieren:
```yaml
api:
  encryption:
    key: !secret api_encryption_key
  reboot_timeout: 15min
```

**Sicherheitsgewinn:** 
- ✅ Verschlüsselte Kommunikation (AES-128)
- ✅ Schutz vor Abhören
- ✅ Schutz vor Manipulation

---

#### 2. OTA-Passwort aktivieren

**Schritt 1:** Starkes Passwort in `secrets.yaml`:
```yaml
ota_password: "DeinStarkesPasswort123!@#"
```

**Schritt 2:** In `g13_led_stehlampe_ha.yaml` aktivieren:
```yaml
ota:
  - platform: esphome
    password: !secret ota_password
    port: 3232
```

**Sicherheitsgewinn:**
- ✅ Schutz vor unbefugten Firmware-Updates
- ✅ Verhindert Malware-Installation

---

### Priorität 2: HOCH - Bald umsetzen

#### 3. Access Point Passwort setzen

**Schritt 1:** Passwort in `secrets.yaml`:
```yaml
ap_password: "StarkesAPPasswort123!"
```

**Schritt 2:** In `g13_led_stehlampe_ha.yaml` aktivieren:
```yaml
wifi:
  ap:
    ssid: "G13-LED-Stehlampe"
    password: !secret ap_password
```

**Sicherheitsgewinn:**
- ✅ Geschützter Fallback-AP
- ✅ Verhindert offenes WLAN

---

#### 4. ESP32 Improv mit Authentifizierung

**Option A:** Improv komplett deaktivieren (wenn nicht benötigt)
```yaml
# esp32_improv:
#   authorizer: none
```

**Option B:** Nur bei Bedarf temporär aktivieren

**Sicherheitsgewinn:**
- ✅ Reduzierte Angriffsfläche
- ✅ Keine ungeschützte Bluetooth-Provisionierung

---

### Priorität 3: MITTEL - Optional, aber empfohlen

#### 5. Web Server mit Authentifizierung (falls aktiviert)

```yaml
web_server:
  port: 80
  version: 2
  include_internal: true
  auth:
    username: !secret web_server_username
    password: !secret web_server_password
```

**In `secrets.yaml`:**
```yaml
web_server_username: "admin"
web_server_password: "StarkesWebPasswort123!"
```

---

#### 6. WiFi-Netzwerk-Sicherheit

**Empfehlungen:**
- ✅ WPA3 verwenden (falls Router unterstützt)
- ✅ Starke WiFi-Passwörter (min. 20 Zeichen)
- ✅ Separates IoT-Netzwerk (VLAN)
- ✅ Firewall-Regeln für IoT-Geräte

---

#### 7. Netzwerk-Isolation (Router-Level)

**Empfohlene Router-Konfiguration:**
```
IoT-VLAN:
  - Kein Internet-Zugriff (optional)
  - Nur Kommunikation mit Home Assistant
  - Keine Kommunikation zwischen IoT-Geräten
  - Firewall-Regeln:
    * ESP → HA: Erlaubt
    * ESP → Internet: Blockiert
    * Internet → ESP: Blockiert
```

---

#### 8. Regelmäßige Updates

- ✅ ESPHome regelmäßig aktualisieren
- ✅ Sicherheits-Patches einspielen
- ✅ Alte Konfigurationen prüfen

---

## 🔒 Sicherheits-Checkliste

### Vor dem Produktivbetrieb:

- [ ] API-Verschlüsselung aktiviert
- [ ] OTA-Passwort gesetzt
- [ ] Access Point Passwort gesetzt
- [ ] Improv deaktiviert oder geschützt
- [ ] Starke Passwörter verwendet (min. 16 Zeichen)
- [ ] Secrets.yaml nicht in Git committed
- [ ] Router-Firewall konfiguriert
- [ ] IoT-Netzwerk isoliert (optional, aber empfohlen)

### Regelmäßige Wartung:

- [ ] ESPHome-Updates einspielen
- [ ] Passwörter regelmäßig rotieren
- [ ] Logs auf verdächtige Aktivitäten prüfen
- [ ] Netzwerk-Traffic überwachen

---

## 📊 Sicherheitsbewertung

### Aktueller Status: ⚠️ **UNGENÜGEND**

| Bereich | Status | Risiko |
|---------|--------|--------|
| API-Verschlüsselung | ❌ Deaktiviert | 🔴 KRITISCH |
| OTA-Schutz | ❌ Kein Passwort | 🟠 HOCH |
| Access Point | ❌ Offen | 🟡 MITTEL |
| Bluetooth Improv | ⚠️ Ungeschützt | 🟡 MITTEL |
| Web Server | ✅ Deaktiviert | ✅ OK |

### Nach Implementierung: ✅ **GUT**

| Bereich | Status | Risiko |
|---------|--------|--------|
| API-Verschlüsselung | ✅ Aktiviert | ✅ NIEDRIG |
| OTA-Schutz | ✅ Passwort | ✅ NIEDRIG |
| Access Point | ✅ Passwort | ✅ NIEDRIG |
| Bluetooth Improv | ✅ Deaktiviert | ✅ NIEDRIG |
| Web Server | ✅ Deaktiviert | ✅ OK |

---

## 🛡️ Zusätzliche Sicherheitsmaßnahmen (Fortgeschritten)

### 1. Certificate Pinning (für externe HTTPS-Verbindungen)

**Status:** ⚠️ Optional (nur bei externen HTTPS-APIs erforderlich)

**Hinweis:** Certificate Pinning ist für die API-Kommunikation mit Home Assistant **nicht erforderlich**, da bereits das Noise Protocol Framework mit Verschlüsselung verwendet wird. Certificate Pinning ist nur relevant für externe HTTPS-Verbindungen (z.B. `http_request` Komponente).

Siehe `CERTIFICATE_PINNING.md` für Details.
```yaml
api:
  encryption:
    key: !secret api_encryption_key
  # Optional: Certificate Pinning für zusätzliche Sicherheit
```

### 2. Rate Limiting (Router-Level)
- Begrenze Verbindungsversuche
- Blockiere verdächtige IPs

### 3. Intrusion Detection
- Home Assistant: `network` Integration für Traffic-Monitoring
- Router-Logs analysieren

### 4. Backup & Recovery
- Konfigurationen sichern
- Recovery-Plan für kompromittierte Geräte

---

## 📚 Weitere Ressourcen

- [ESPHome Security Best Practices](https://esphome.io/guides/security.html)
- [Home Assistant Security](https://www.home-assistant.io/docs/security/)
- [OWASP IoT Security](https://owasp.org/www-project-internet-of-things/)

---

## ⚠️ WICHTIGER HINWEIS

**Diese Geräte haben Zugriff auf dein Heimnetzwerk!**
- Implementiere mindestens die **Priorität 1** Maßnahmen
- Teste die Konfiguration vor Produktivbetrieb
- Überwache die Geräte regelmäßig

