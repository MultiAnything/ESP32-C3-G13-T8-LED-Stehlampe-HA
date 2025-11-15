#!/bin/bash
# ESPHome Lokale Installation Script
# Für Linux/macOS

set -e  # Stoppe bei Fehlern

echo "=========================================="
echo "ESPHome Lokale Installation"
echo "=========================================="
echo ""

# Prüfe Python
echo "1. Prüfe Python Installation..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 nicht gefunden!"
    echo "Bitte installiere Python3 zuerst."
    exit 1
fi

PYTHON_VERSION=$(python3 --version)
echo "✅ $PYTHON_VERSION gefunden"
echo ""

# Prüfe pip
echo "2. Prüfe pip Installation..."
if ! command -v pip3 &> /dev/null; then
    echo "⚠️  pip3 nicht gefunden, versuche zu installieren..."
    python3 -m ensurepip --upgrade
fi

echo "✅ pip3 gefunden"
echo ""

# Erstelle virtuelle Umgebung
echo "3. Erstelle virtuelle Umgebung..."
if [ -d "esphome-env" ]; then
    echo "⚠️  Virtuelle Umgebung existiert bereits"
    read -p "Neu erstellen? (j/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Jj]$ ]]; then
        rm -rf esphome-env
        python3 -m venv esphome-env
        echo "✅ Virtuelle Umgebung erstellt"
    else
        echo "✅ Verwende existierende virtuelle Umgebung"
    fi
else
    python3 -m venv esphome-env
    echo "✅ Virtuelle Umgebung erstellt"
fi
echo ""

# Aktiviere virtuelle Umgebung
echo "4. Aktiviere virtuelle Umgebung..."
source esphome-env/bin/activate
echo "✅ Virtuelle Umgebung aktiviert"
echo ""

# Aktualisiere pip
echo "5. Aktualisiere pip..."
pip install --upgrade pip --quiet
echo "✅ pip aktualisiert"
echo ""

# Installiere ESPHome
echo "6. Installiere ESPHome..."
pip install esphome --quiet
echo "✅ ESPHome installiert"
echo ""

# Prüfe Installation
echo "7. Prüfe Installation..."
ESPHOME_VERSION=$(esphome version)
echo "✅ ESPHome $ESPHOME_VERSION installiert"
echo ""

# Prüfe Secrets
echo "8. Prüfe Secrets-Datei..."
if [ ! -f "secrets.yaml" ]; then
    if [ -f "secrets.yaml.example" ]; then
        echo "⚠️  secrets.yaml nicht gefunden"
        read -p "Aus secrets.yaml.example erstellen? (j/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Jj]$ ]]; then
            cp secrets.yaml.example secrets.yaml
            echo "✅ secrets.yaml erstellt (bitte bearbeiten!)"
        fi
    else
        echo "⚠️  secrets.yaml.example nicht gefunden"
    fi
else
    echo "✅ secrets.yaml gefunden"
fi
echo ""

# Zusammenfassung
echo "=========================================="
echo "✅ Installation abgeschlossen!"
echo "=========================================="
echo ""
echo "Nächste Schritte:"
echo ""
echo "1. Aktiviere virtuelle Umgebung:"
echo "   source esphome-env/bin/activate"
echo ""
echo "2. Validiere Konfiguration:"
echo "   esphome config g13_led_stehlampe_ha.yaml"
echo ""
echo "3. Kompiliere Firmware:"
echo "   esphome compile g13_led_stehlampe_ha.yaml"
echo ""
echo "4. Flashe Firmware:"
echo "   esphome upload g13_led_stehlampe_ha.yaml --device /dev/ttyUSB0"
echo ""
echo "Für weitere Informationen siehe LOKALE_INSTALLATION.md"
echo ""

