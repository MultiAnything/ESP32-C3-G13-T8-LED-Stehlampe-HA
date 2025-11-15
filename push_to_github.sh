#!/bin/bash
# Script zum Hochladen des Repositories zu GitHub
# Führe dieses Script aus, nachdem du das Repository auf GitHub erstellt hast

set -e

echo "🚀 GitHub Repository Upload Script"
echo "===================================="
echo ""

# Prüfe, ob Remote bereits existiert
if git remote get-url origin &>/dev/null; then
    echo "⚠️  Remote 'origin' existiert bereits:"
    git remote -v
    echo ""
    read -p "Möchtest du den Remote ändern? (j/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Jj]$ ]]; then
        read -p "GitHub Repository URL (z.B. https://github.com/MultiAnything/ESP32-C3-G13-LED-Stehlampe-HA.git): " REPO_URL
        git remote set-url origin "$REPO_URL"
        echo "✅ Remote aktualisiert"
    fi
else
    echo "📝 Remote 'origin' hinzufügen..."
    read -p "GitHub Repository URL (z.B. https://github.com/MultiAnything/ESP32-C3-G13-LED-Stehlampe-HA.git): " REPO_URL
    git remote add origin "$REPO_URL"
    echo "✅ Remote hinzugefügt"
fi

echo ""
echo "📋 Repository Status:"
git status --short

echo ""
echo "🔒 Sicherheitsprüfung:"
if git ls-files | grep -q "secrets.yaml$"; then
    echo "❌ FEHLER: secrets.yaml ist im Repository!"
    echo "   Entferne sie mit: git rm --cached secrets.yaml"
    exit 1
else
    echo "✅ secrets.yaml ist NICHT im Repository (gut!)"
fi

echo ""
echo "📤 Push zu GitHub..."
echo ""

# Prüfe, ob SSH funktioniert
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH-Authentifizierung funktioniert"
    git push -u origin main
else
    echo "⚠️  SSH-Authentifizierung nicht verfügbar"
    echo "   Verwende HTTPS (Personal Access Token wird benötigt)"
    echo ""
    echo "📝 Personal Access Token erstellen:"
    echo "   1. Gehe zu: https://github.com/settings/tokens"
    echo "   2. Generate new token (classic)"
    echo "   3. Scopes: repo (Full control)"
    echo "   4. Kopiere den Token"
    echo ""
    git push -u origin main
fi

echo ""
echo "✅ Push erfolgreich!"
echo ""
echo "🌐 Repository URL:"
git remote get-url origin | sed 's/\.git$//'
echo ""
echo "📚 Nächste Schritte:"
echo "   - Repository-Einstellungen auf GitHub prüfen"
echo "   - Topics hinzufügen: esphome, esp32-c3, home-assistant"
echo "   - Optional: License hinzufügen"

