# Verschlüsselung in ESPHome - Technische Details

## 🔐 Aktuelle Implementierung

ESPHome verwendet **nicht direkt AES**, sondern das **Noise Protocol Framework** für die API-Verschlüsselung.

### Technische Spezifikation

- **Protokoll:** Noise Protocol Framework
- **Schlüssellänge:** 32 Bytes (256 Bit)
- **Format:** Base64-kodiert
- **Bibliothek:** `esphome/noise-c` Version 0.1.6

### Warum Noise Protocol Framework?

Das Noise Protocol Framework bietet:
- ✅ **Forward Secrecy** - Vergangene Nachrichten bleiben auch bei Kompromittierung sicher
- ✅ **Authentifizierung** - Schutz vor Man-in-the-Middle-Angriffen
- ✅ **Moderne Kryptographie** - ChaCha20-Poly1305 oder AES-256-GCM
- ✅ **Efficiency** - Optimiert für ressourcenarme Geräte

---

## ❌ AES-512 existiert nicht

### Verfügbare AES-Varianten

| Variante | Schlüssellänge | Status |
|----------|----------------|--------|
| **AES-128** | 128 Bit (16 Bytes) | ✅ Standard, sehr sicher |
| **AES-192** | 192 Bit (24 Bytes) | ✅ Standard, sehr sicher |
| **AES-256** | 256 Bit (32 Bytes) | ✅ Standard, extrem sicher |
| **AES-512** | ❌ | **Existiert nicht!** |

### Warum gibt es kein AES-512?

1. **Nicht standardisiert** - AES wurde nur für 128, 192 und 256 Bit spezifiziert
2. **Keine Implementierungen** - Keine Hardware- oder Software-Unterstützung
3. **Nicht notwendig** - AES-256 ist bereits kryptographisch sicher

---

## 🔒 Ist AES-256 (32 Bytes) sicher genug?

### ✅ JA - Absolut sicher!

**AES-256 Sicherheit:**
- **Brute-Force-Angriff:** Würde länger dauern als das Alter des Universums
- **Quantencomputer-resistent:** Selbst mit Quantencomputern praktisch nicht knackbar
- **Militärischer Standard:** Wird für Top-Secret-Daten verwendet

### Vergleich der Sicherheit

| Schlüssellänge | Brute-Force-Versuche | Zeit (bei 1 Billion/s) |
|----------------|---------------------|------------------------|
| AES-128 | 2^128 | ~10^13 Jahre |
| AES-192 | 2^192 | ~10^40 Jahre |
| **AES-256** | **2^256** | **~10^56 Jahre** |

**Fazit:** AES-256 ist für alle praktischen Zwecke unknackbar.

---

## ⚠️ Warum wäre AES-512 (wenn es existierte) nicht sinnvoll?

### 1. **Keine zusätzliche Sicherheit**
- AES-256 ist bereits kryptographisch sicher
- Mehr Bits = keine messbare Sicherheitsverbesserung
- Das Problem liegt nicht in der Verschlüsselung, sondern in:
  - Schwachen Passwörtern
  - Fehlender Authentifizierung
  - Implementierungsfehlern

### 2. **Performance-Probleme**
- **Mehr Rechenzeit** - Längere Verschlüsselungszeiten
- **Mehr Speicher** - Größere Schlüssel benötigen mehr RAM
- **Mehr Energie** - Höherer Stromverbrauch
- **Langsamere Verbindung** - Höhere Latenz

### 3. **Kompatibilitätsprobleme**
- **Keine Hardware-Unterstützung** - ESP32-C3 hat AES-Hardware nur für 128/256 Bit
- **Keine Software-Bibliotheken** - Keine Standard-Implementierungen
- **Inkompatibilität** - Andere Geräte könnten nicht kommunizieren

### 4. **Ressourcen-Limitierung**
ESP32-C3 hat begrenzte Ressourcen:
- **RAM:** 320 KB
- **Flash:** 4 MB
- **CPU:** 160 MHz

Größere Schlüssel würden diese Ressourcen unnötig belasten.

---

## 📊 Vergleich: Aktuelle vs. Hypothetische AES-512

| Aspekt | AES-256 (aktuell) | AES-512 (hypothetisch) |
|--------|-------------------|------------------------|
| **Sicherheit** | ✅ Extrem sicher | ✅ Extrem sicher (kein Mehrwert) |
| **Performance** | ✅ Schnell | ❌ Langsamer |
| **Speicher** | ✅ 32 Bytes | ❌ 64 Bytes |
| **Energie** | ✅ Niedrig | ❌ Höher |
| **Kompatibilität** | ✅ Standard | ❌ Nicht verfügbar |
| **Hardware-Support** | ✅ ESP32-C3 unterstützt | ❌ Nicht unterstützt |

**Fazit:** AES-256 ist die optimale Wahl!

---

## 🛡️ Was macht dein System wirklich sicher?

### Priorität 1: Verschlüsselung aktivieren ✅
- API-Verschlüsselung mit 32-Byte-Key (bereits implementiert)
- Noise Protocol Framework (bereits aktiv)

### Priorität 2: Starke Authentifizierung
- ✅ OTA-Passwort setzen
- ✅ Access Point Passwort setzen
- ✅ Starke WiFi-Passwörter

### Priorität 3: Netzwerk-Sicherheit
- ✅ Firewall-Regeln
- ✅ IoT-VLAN (isoliert)
- ✅ Regelmäßige Updates

### Priorität 4: Best Practices
- ✅ Secrets sicher speichern
- ✅ Passwörter regelmäßig rotieren
- ✅ Logs überwachen

---

## 🔬 Technische Details: Noise Protocol Framework

### Noise Protocol Handshake

ESPHome verwendet wahrscheinlich **Noise_XX_25519_ChaChaPoly_BLAKE2s**:
- **XX:** Handshake-Pattern (mutual authentication)
- **25519:** Curve25519 für Key Exchange
- **ChaChaPoly:** ChaCha20-Poly1305 für Verschlüsselung
- **BLAKE2s:** Hash-Funktion

### Warum besser als direktes AES?

1. **Perfect Forward Secrecy** - Jede Session hat eigene Keys
2. **Authentifizierung** - Schutz vor MITM-Angriffen
3. **Moderne Kryptographie** - Aktuelle Standards
4. **Efficiency** - Optimiert für IoT-Geräte

---

## 📚 Empfehlungen

### ✅ DO (Tun)

1. **32-Byte Key verwenden** - Das ist optimal
2. **Key sicher speichern** - In `secrets.yaml`, nicht in Git
3. **Regelmäßig rotieren** - Alle 6-12 Monate (optional)
4. **Verschlüsselung aktivieren** - Immer aktiviert lassen

### ❌ DON'T (Nicht tun)

1. **Keine längeren Keys** - 32 Bytes ist das Maximum
2. **Keine schwachen Keys** - Nicht aus Wörterbüchern
3. **Nicht in Git committen** - `secrets.yaml` in `.gitignore`
4. **Nicht teilen** - Jedes Gerät sollte eigenen Key haben

---

## 🎯 Fazit

**AES-512 ist:**
- ❌ Nicht verfügbar (existiert nicht)
- ❌ Nicht notwendig (AES-256 ist bereits extrem sicher)
- ❌ Nicht sinnvoll (Performance-Probleme, keine Kompatibilität)

**Deine aktuelle Konfiguration mit 32-Byte Key ist:**
- ✅ **Optimal** - Maximale Sicherheit für IoT-Geräte
- ✅ **Standard** - Noise Protocol Framework ist modern und sicher
- ✅ **Ausreichend** - Für alle praktischen Zwecke unknackbar

**Fokus sollte sein auf:**
- ✅ Verschlüsselung aktivieren (32-Byte Key)
- ✅ Starke Authentifizierung (Passwörter)
- ✅ Netzwerk-Sicherheit (Firewall, VLAN)
- ✅ Best Practices (Updates, Monitoring)

---

## 📖 Weitere Ressourcen

- [ESPHome Security Documentation](https://esphome.io/guides/security.html)
- [Noise Protocol Framework](https://noiseprotocol.org/)
- [AES Encryption Standard](https://csrc.nist.gov/publications/detail/fips/197/final)
- [NIST Cryptographic Standards](https://csrc.nist.gov/projects/cryptographic-standards-and-guidelines)

