# 🎮 ABAP Game of Life

[![GitHub license](https://img.shields.io/github/license/miggi92/abap-gol?style=for-the-badge)](https://github.com/miggi92/abap-gol/blob/main/LICENSE.md)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/miggi92/abap-gol?style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/miggi92/abap-gol?style=for-the-badge)

Eine objektorientierte Implementierung von Conway's Game of Life in ABAP mit interaktiver ALV-Anzeige.

## 📖 Über das Projekt

Dieses Projekt implementiert [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life), einen zellulären Automaten, der von John Horton Conway entwickelt wurde. Die Implementierung nutzt moderne ABAP-Konzepte und bietet eine visuelle Darstellung über ALV (ABAP List Viewer).

### Conway's Game of Life Regeln

Das Spielfeld besteht aus einem Grid von Zellen, die entweder lebendig oder tot sein können:

1. **Unterbevölkerung**: Eine lebende Zelle mit weniger als 2 lebenden Nachbarn stirbt
2. **Überleben**: Eine lebende Zelle mit 2-3 lebenden Nachbarn überlebt
3. **Überbevölkerung**: Eine lebende Zelle mit mehr als 3 lebenden Nachbarn stirbt
4. **Reproduktion**: Eine tote Zelle mit genau 3 lebenden Nachbarn wird lebendig

## ✨ Features

- 🎯 Objektorientierte ABAP-Implementierung
- 🖥️ Interaktive ALV-Anzeige
- ⚙️ Konfigurierbare Grid-Größe (Zeilen und Spalten)
- 🔄 Automatische Generationswechsel
- ✅ Unit Tests für Core-Logik
- 🔍 ABAPLint-konform

## 🏗️ Projektstruktur

```
src/
├── zcl_gol_controller.*      # Hauptsteuerung des Spiels
├── zcl_gol_grid.*            # Grid-Verwaltung und Logik
├── zcl_gol_cell.*            # Einzelne Zell-Implementierung
├── zcl_gol_alv.*             # ALV-Darstellung
├── zgol_runner.prog.abap     # Executable Report
├── zif_gol_constants.*       # Interface für Konstanten
└── zif_gol_types.*           # Interface für Typdefinitionen
```

## 🚀 Installation

### Voraussetzungen

- SAP System mit ABAP 7.40 oder höher
- Berechtigungen zum Erstellen von ABAP-Objekten

### Schritte

1. **Klonen des Repositories**
   ```bash
   git clone https://github.com/miggi92/abap-gol.git
   ```

2. **Import in SAP System**
   - Nutze abapGit oder manuelle Imports
   - Stelle sicher, dass alle Objekte im Package angelegt werden

3. **Aktivierung**
   - Aktiviere alle ABAP-Objekte im System

## 💻 Verwendung

### Starten des Spiels

1. Führe den Report `ZGOL_RUNNER` aus
2. Gib die gewünschten Parameter ein:
   - `P_COLS`: Anzahl der Spalten (Standard: 30)
   - `P_ROWS`: Anzahl der Zeilen (Standard: 15)
3. Klicke auf "Ausführen" (F8)

### Im Spiel

- Die ALV-Ansicht zeigt das aktuelle Grid
- Klicke auf "Nächste Generation", um die Simulation fortzusetzen
- Beobachte, wie sich die Zellen nach den Game of Life Regeln entwickeln

## 🛠️ Entwicklung

### Setup für lokale Entwicklung

```bash
# Abhängigkeiten installieren
pnpm install

# ABAPLint prüfen
pnpm run abaplint

# Unit Tests ausführen (Transpiler)
pnpm run test
```

### Dependencies

#### ABAPLint

![GitHub package.json dependency version (dev dep on branch)](https://img.shields.io/github/package-json/dependency-version/miggi92/abap-gol/dev/@abaplint/cli?style=for-the-badge)
![GitHub package.json dependency version (dev dep on branch)](https://img.shields.io/github/package-json/dependency-version/miggi92/abap-gol/dev/@abaplint/runtime?style=for-the-badge)
![GitHub package.json dependency version (dev dep on branch)](https://img.shields.io/github/package-json/dependency-version/miggi92/abap-gol/dev/@abaplint/transpiler-cli?style=for-the-badge)

### Code-Qualität

Die ABAPLint-Statistiken können unter [abaplint.app/stats/miggi92/abap-gol](https://abaplint.app/stats/miggi92/abap-gol) eingesehen werden.

## 🧪 Testing

Das Projekt enthält Unit Tests für die Kern-Logik:
- Tests für `zcl_gol_controller`
- Tests für `zcl_gol_grid`

Tests können über den Transpiler oder direkt im SAP System ausgeführt werden.

## 🤝 Contributing

Beiträge sind willkommen! Bitte beachte:

1. Fork das Projekt
2. Erstelle einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. Committe deine Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Pushe zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne einen Pull Request

Weitere Details findest du in [CONTRIBUTING.md](./CONTRIBUTING.md).

## 📄 Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert. Details siehe [LICENSE.md](./LICENSE.md).

## 💖 Sponsors

![Sponsors](https://github.com/miggi92/static/blob/master/sponsors.svg)

## 📞 Kontakt

[@miggi92](https://github.com/miggi92)

Projekt Link: [https://github.com/miggi92/abap-gol](https://github.com/miggi92/abap-gol)

---

⭐ Wenn dir dieses Projekt gefällt, gib ihm einen Stern!
