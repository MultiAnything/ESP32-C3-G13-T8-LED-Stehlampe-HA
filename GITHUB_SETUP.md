# 🚀 GitHub Repository Setup

## Schritt 1: GitHub Repository erstellen

1. Gehe zu: https://github.com/new
2. **Repository name:** `ESP32-C3-G13-LED-Stehlampe-HA` (oder einen anderen Namen)
3. **Description:** `Smart Home Controller für G13 LED Stehlampe mit ESP32-C3 und Home Assistant Integration`
4. **Visibility:** 
   - ✅ **Public** (empfohlen für Open Source)
   - Oder **Private** (falls du es privat halten möchtest)
5. **WICHTIG:** 
   - ❌ **NICHT** "Add a README file" aktivieren (wir haben bereits eine)
   - ❌ **NICHT** "Add .gitignore" aktivieren (wir haben bereits eine)
   - ❌ **NICHT** "Choose a license" aktivieren (optional, später möglich)
6. Klicke auf **"Create repository"**

## Schritt 2: Remote Repository hinzufügen

Nach dem Erstellen des Repositories zeigt GitHub dir die Befehle an. Führe diese lokal aus:

```bash
cd "/home/sam/Dokumente/PlatformIO/Projects/ESP32-C3 G13_LED_UltraSlim Stehlampe-HA"

# Remote hinzufügen (ersetze USERNAME mit deinem GitHub-Username)
git remote add origin https://github.com/MultiAnything/ESP32-C3-G13-LED-Stehlampe-HA.git

# Oder mit SSH (falls du SSH-Keys eingerichtet hast):
# git remote add origin git@github.com:MultiAnything/ESP32-C3-G13-LED-Stehlampe-HA.git
```

## Schritt 3: Branch umbenennen (optional, aber empfohlen)

```bash
# Branch von 'master' zu 'main' umbenennen
git branch -M main
```

## Schritt 4: Ersten Push durchführen

### Option A: Mit HTTPS (benötigt Personal Access Token)

**4.1 Personal Access Token erstellen:**

1. Gehe zu: https://github.com/settings/tokens
2. Klicke auf **"Generate new token"** → **"Generate new token (classic)"**
3. **Note:** `ESP32-C3 Stehlampe Repository`
4. **Expiration:** Wähle eine Ablaufzeit (z.B. 90 Tage oder "No expiration")
5. **Scopes:** Aktiviere mindestens:
   - ✅ `repo` (Full control of private repositories)
6. Klicke auf **"Generate token"**
7. **WICHTIG:** Kopiere den Token sofort! Er wird nur einmal angezeigt!

**4.2 Push mit Token:**

```bash
# Push durchführen (Token wird als Passwort abgefragt)
git push -u origin main

# Username: MultiAnything
# Password: [Dein Personal Access Token]
```

### Option B: Mit SSH (empfohlen für dauerhafte Nutzung)

**4.1 SSH-Key erstellen (falls noch nicht vorhanden):**

```bash
# Prüfe, ob bereits SSH-Keys existieren
ls -la ~/.ssh/id_*.pub

# Falls keine existieren, erstelle einen neuen:
ssh-keygen -t ed25519 -C "deine-email@example.com"
# Drücke Enter für alle Fragen (Standard-Werte)

# Zeige den öffentlichen Key an
cat ~/.ssh/id_ed25519.pub
```

**4.2 SSH-Key zu GitHub hinzufügen:**

1. Kopiere den öffentlichen Key (Ausgabe von `cat ~/.ssh/id_ed25519.pub`)
2. Gehe zu: https://github.com/settings/keys
3. Klicke auf **"New SSH key"**
4. **Title:** `ESP32-C3 Stehlampe Development`
5. **Key:** Füge den kopierten Key ein
6. Klicke auf **"Add SSH key"**

**4.3 Remote auf SSH umstellen:**

```bash
# Remote auf SSH ändern
git remote set-url origin git@github.com:MultiAnything/ESP32-C3-G13-LED-Stehlampe-HA.git

# Push durchführen
git push -u origin main
```

## Schritt 5: Verifizierung

Nach erfolgreichem Push:

1. Gehe zu: https://github.com/MultiAnything/ESP32-C3-G13-LED-Stehlampe-HA
2. Prüfe, ob alle Dateien vorhanden sind
3. **WICHTIG:** Prüfe, dass `secrets.yaml` NICHT im Repository ist!

## 🔒 Sicherheits-Checkliste

Vor dem Push:

- [ ] `secrets.yaml` ist in `.gitignore`
- [ ] Keine Passwörter in YAML-Dateien (nur `!secret` Referenzen)
- [ ] Keine WLAN-Namen in YAML-Dateien
- [ ] `secrets.yaml.example` enthält nur Platzhalter
- [ ] Alle sensiblen Daten entfernt

## 📝 Nächste Schritte nach dem Push

### Repository-Einstellungen

1. **Description hinzufügen:**
   - Gehe zu Repository → Settings → General
   - Füge eine Beschreibung hinzu

2. **Topics hinzufügen:**
   - Gehe zu Repository → Klicke auf das Zahnrad-Symbol
   - Füge Topics hinzu: `esphome`, `esp32-c3`, `home-assistant`, `smart-home`, `iot`

3. **License hinzufügen (optional):**
   - Gehe zu Repository → Settings → General → Scroll nach unten
   - Klicke auf "Add license"
   - Wähle eine Lizenz (z.B. MIT, GPL-3.0, etc.)

4. **README verbessern:**
   - Die README.md ist bereits vorhanden
   - Optional: Badges hinzufügen (siehe unten)

### Badges für README (optional)

Füge diese Zeile am Anfang der README.md hinzu:

```markdown
![ESPHome](https://img.shields.io/badge/ESPHome-2025.5.2-blue)
![ESP32-C3](https://img.shields.io/badge/ESP32--C3-DevKitM--1-green)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Integration-orange)
![License](https://img.shields.io/badge/License-MIT-yellow)
```

## 🐛 Troubleshooting

### Fehler: "remote: Support for password authentication was removed"

**Lösung:** Verwende einen Personal Access Token statt Passwort:
1. Erstelle einen Token (siehe Schritt 4.1)
2. Verwende den Token als Passwort beim Push

### Fehler: "Permission denied (publickey)"

**Lösung:** SSH-Key ist nicht zu GitHub hinzugefügt:
1. Prüfe: `ssh -T git@github.com`
2. Falls Fehler: Füge SSH-Key zu GitHub hinzu (siehe Schritt 4.2)

### Fehler: "Repository not found"

**Lösung:** 
1. Prüfe, ob der Repository-Name korrekt ist
2. Prüfe, ob du Zugriff auf das Repository hast
3. Prüfe die Remote-URL: `git remote -v`

## 📚 Weitere Informationen

- [GitHub Docs: Creating a new repository](https://docs.github.com/en/get-started/quickstart/create-a-repo)
- [GitHub Docs: Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub Docs: SSH Keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

