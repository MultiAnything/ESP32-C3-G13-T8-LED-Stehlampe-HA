# 📋 YAML-Dateien Analyse

## ✅ Benötigte Dateien (BEHALTEN)

### 1. `g13_led_stehlampe_ha.yaml` (7,1K) - **HAUPTDATEI**
- **Status:** ✅ **WIRD BENÖTIGT**
- **Verwendung:** Hauptkonfiguration für Home Assistant ESPHome-Erweiterung
- **Enthält:** Vollständige aktuelle Konfiguration mit allen Features
- **Aktion:** BEHALTEN

### 2. `secrets.yaml` (838B) - **SENSIBLE DATEN**
- **Status:** ✅ **WIRD BENÖTIGT**
- **Verwendung:** Enthält WiFi-Credentials, API-Key, Passwörter
- **Wichtig:** Ist in `.gitignore` und wird NICHT in Git committed
- **Aktion:** BEHALTEN (aber nicht in Git)

### 3. `secrets.yaml.example` - **VORLAGE**
- **Status:** ✅ **WIRD BENÖTIGT**
- **Verwendung:** Vorlage für andere Benutzer (ohne echte Werte)
- **Aktion:** BEHALTEN

---

## ⚠️ Optionale Dateien (KANN BEHALTEN WERDEN)

### 4. `home_assistant_card_wifi.yaml` (2,3K) - **BEISPIEL**
- **Status:** ⚠️ **OPTIONAL** (Beispiel-Datei)
- **Verwendung:** Home Assistant Lovelace-Karten-Konfiguration (nicht ESPHome)
- **Zweck:** Beispiel für WiFi-Signal-Anzeige in HA
- **Aktion:** KANN BEHALTEN WERDEN (als Beispiel) oder in Dokumentation verschieben

---

## ❌ Veraltete/Redundante Dateien (KÖNNEN GELÖSCHT WERDEN)

### 5. `g13_led_stehlampe.yaml` (4,3K) - **VERALTET**
- **Status:** ❌ **VERALTET**
- **Grund:** Alternative lokale Konfiguration, veraltet
- **Problem:** Enthält alte Konfiguration ohne aktuelle Optimierungen
- **Aktion:** LÖSCHEN (wird nicht mehr verwendet)

### 6. `led_t8_controller.yaml` (3,8K) - **VERALTET**
- **Status:** ❌ **VERALTET**
- **Grund:** Ursprüngliche/erste Konfiguration
- **Problem:** Enthält `platformio_options` (nicht mehr unterstützt)
- **Aktion:** LÖSCHEN (wird nicht mehr verwendet)

### 7. `g13_led_stehlampe_ha_SICHER.yaml` (6,8K) - **VORLAGE**
- **Status:** ⚠️ **OPTIONAL** (Sicherheits-Vorlage)
- **Grund:** Beispiel-Konfiguration mit Sicherheitshinweisen
- **Problem:** Redundant, da aktuelle Konfiguration bereits sicher ist
- **Aktion:** KANN GELÖSCHT WERDEN (oder in Dokumentation verschieben)

### 8. `temp_read_address.yaml` (366B) - **TEMPORÄR**
- **Status:** ❌ **TEMPORÄR** (nicht mehr benötigt)
- **Grund:** Wurde nur zum Auslesen der DS18B20 Adresse verwendet
- **Problem:** Adresse wurde bereits ausgelesen, Datei nicht mehr benötigt
- **Aktion:** LÖSCHEN

---

## 📊 Zusammenfassung

| Datei | Status | Größe | Aktion |
|-------|--------|-------|--------|
| `g13_led_stehlampe_ha.yaml` | ✅ Benötigt | 7,1K | **BEHALTEN** |
| `secrets.yaml` | ✅ Benötigt | 838B | **BEHALTEN** (nicht in Git) |
| `secrets.yaml.example` | ✅ Benötigt | - | **BEHALTEN** |
| `home_assistant_card_wifi.yaml` | ⚠️ Optional | 2,3K | **OPTIONAL** (Beispiel) |
| `g13_led_stehlampe.yaml` | ❌ Veraltet | 4,3K | **LÖSCHEN** |
| `led_t8_controller.yaml` | ❌ Veraltet | 3,8K | **LÖSCHEN** |
| `g13_led_stehlampe_ha_SICHER.yaml` | ⚠️ Vorlage | 6,8K | **LÖSCHEN** (optional) |
| `temp_read_address.yaml` | ❌ Temporär | 366B | **LÖSCHEN** |

---

## 🗑️ Empfohlene Löschungen

**Sicher löschen:**
- `g13_led_stehlampe.yaml` (veraltet)
- `led_t8_controller.yaml` (veraltet)
- `temp_read_address.yaml` (temporär, nicht mehr benötigt)

**Optional löschen:**
- `g13_led_stehlampe_ha_SICHER.yaml` (Vorlage, redundant)
- `home_assistant_card_wifi.yaml` (kann in Dokumentation verschoben werden)

**Gesamteinsparung:** ~14,8K (wenn alle optionalen gelöscht werden)

---

## ✅ Nach Bereinigung verbleibend

1. `g13_led_stehlampe_ha.yaml` - Hauptkonfiguration
2. `secrets.yaml` - Sensible Daten (nicht in Git)
3. `secrets.yaml.example` - Vorlage

**Optional:**
- `home_assistant_card_wifi.yaml` - Als Beispiel behalten

---

**Empfehlung:** Lösche die 3 veralteten Dateien (`g13_led_stehlampe.yaml`, `led_t8_controller.yaml`, `temp_read_address.yaml`) und optional die Vorlagen-Dateien.

