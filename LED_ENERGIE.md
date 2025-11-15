# 💡 LED-Deaktivierung und Energieverbrauch

## ⚠️ Problem: Output-Pin verbraucht Energie

### Warum mehr Energieverbrauch mit Output-Pin?

**Das Problem:**
- Ein aktiver GPIO-Output-Pin verbraucht minimal Energie (~0,01-0,05 mW)
- Auch wenn der Pin nur HIGH hält (LED aus)
- Der Pin muss aktiv gehalten werden = kontinuierlicher minimaler Verbrauch

**Vorher (LED ungenutzt):**
- Kein Output-Pin aktiv
- LED wird nicht gesteuert
- **Energieverbrauch: 0 mW** (LED ignoriert)

**Nachher (LED mit Output-Pin "deaktiviert"):**
- Output-Pin aktiv (HIGH = LED aus)
- Pin muss aktiv gehalten werden
- **Energieverbrauch: ~0,01-0,05 mW** (minimal, aber vorhanden)

---

## ✅ Lösung: LED einfach ignorieren

**Beste Methode:** Die LED einfach nicht steuern!

- ✅ Kein Output-Pin = kein Energieverbrauch
- ✅ Keine zusätzliche Konfiguration nötig
- ✅ LED bleibt ungenutzt (kann blinken, verbraucht aber keine Energie durch Steuerung)

**Alternative (falls LED wirklich aus sein muss):**
- Pin als Input konfigurieren (weniger Energie als Output)
- Oder Pin komplett ungenutzt lassen (beste Option)

---

## 📊 Energievergleich

| Methode | Energieverbrauch | LED-Status |
|---------|------------------|------------|
| **LED ungenutzt** | 0 mW | Kann blinken (ESPHome steuert sie) |
| **Output HIGH (LED aus)** | ~0,01-0,05 mW | Aus |
| **Output LOW (LED an)** | ~1-5 mW | An |
| **Input-Pin** | ~0,001 mW | Unbestimmt |

**Fazit:** LED einfach ignorieren = 0 mW zusätzlicher Verbrauch! ✅

---

## 🔧 Aktuelle Lösung

Die LED-Deaktivierung wurde entfernt. Die LED wird jetzt ignoriert:
- ✅ Kein Output-Pin = kein Energieverbrauch
- ✅ LED kann blinken (wird von ESPHome gesteuert, falls aktiv)
- ✅ Minimaler Energieverbrauch

**Falls die LED stört:**
- Hardware-Lösung: LED physisch entfernen oder abkleben
- Software-Lösung: Pin als Input konfigurieren (minimaler Verbrauch)

