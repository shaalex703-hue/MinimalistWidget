# Minimalist Phone iOS – Widgets & Launcher Suite

Verwandelt jedes iPhone in ein ablenkungsfreies, radikal minimalistisches Telefon im Stil von *Minimalist Phone* / *Blank Spaces*:
- **Keine bunten Icons oder Notification-Badges auf dem Home-Bildschirm**: Apps werden in die App-Mediathek verschoben.
- **Tiefschwarzer Hintergrund (`#000000`)**: Die Widgets verschmelzen vollkommen nahtlos mit dem OLED-Display deines iPhones.
- **Alles läuft über reine Text-Widgets**: Dezente Datums- und Zeitanzeige sowie konfigurierbare Favoriten-Apps in weißer Systemschrift (`-apple-system`), die sich per Fingertipp direkt öffnen.
- **Integrierte 10-Sekunden Achtsamkeits-Pause**: Fängt zeitfressende Social-Media-Apps (z. B. Instagram, TikTok, YouTube, X, Reddit) vor dem Start mit einem animierten Countdown und Reflexionsfrage ab.

---

## 📱 Widget-Suite & Features

- **Modularität**:
  - **Minimalist Launcher Groß (`.systemLarge`)**: Kopfbereich mit Wochentag, Datum und Uhrzeit + 6 Favoriten-Slots.
  - **Minimalist Launcher Mittel (`.systemMedium`)**: Split-Layout mit Uhrzeit & Datum links und Schnellzugriff auf 3 Apps rechts.
  - **Minimalist Launcher Klein (`.systemSmall`)**: 3 Schnellzugriff-Apps mit Uhrzeit.
  - **Minimalist Zitat & Zeit (`.systemMedium` & `.systemSmall`)**: Dezente Uhrzeitanzeige mit täglichen Achtsamkeits- und Fokus-Impulsen (*„Weniger Bildschirm, mehr Leben.“*).
- **Monochromes Design**:
  - Hintergrund: Reines Tiefschwarz (`Color.black` / `#000000`).
  - Typografie: Reiner weißer Text mit `Font.system(size: 17, weight: .light)`.
- **SelectFavoritesIntent & SelectQuoteIntent (AppIntents)**:
  - Nutzer können das Widget auf dem Home-Bildschirm gedrückt halten und unter **„Widget bearbeiten“** Slots 1 bis 6 sowie das gewünschte Zitat individuell anpassen.
  - Unterstützt alle System-Apps (Telefon, Nachrichten, WhatsApp, Spotify, Notizen, Kamera, Safari, Musik, etc.).
- **Achtsamkeits-Pause (Mindful Pause Interception)**:
  - Social-Media-Apps leiten über `minimalist://intervene` in die Begleit-App.
  - Ein vollflächiger schwarzer 10-Sekunden Zwischenscreen zählt rückwärts.
  - Erst nach Ablauf der 10 Sekunden wird der Button **„Weiter“** aktivierbar.
  - Ein Klick auf **„Abbrechen“** schließt den Screen, die App bleibt geschlossen.

---

## 📂 Projektstruktur

```text
c:\Users\valer\Desktop\IOS/
│
├── MinimalistWidget/                 # Das WidgetKit Extension Target
│   ├── SelectFavoritesIntent.swift   # SelectFavoritesIntent & SystemApp AppEnum mit Deep Links
│   ├── TimeWastingApps.swift         # Erkennung und Scheme-Routing zeitfressender Apps
│   ├── MinimalistWidget.swift        # Widget-Definition & SelectFavoritesTimelineProvider
│   ├── MinimalistWidgetView.swift    # SwiftUI-Ansicht (.systemLarge, pure black, Links)
│   ├── MinimalistWidgetBundle.swift  # WidgetBundle (@main)
│   ├── FavoriteApp.swift             # Datenmodell & Basis-Presets mit widgetDestinationURL
│   ├── MinimalistAppIntent.swift     # Typalias für Abwärtskompatibilität
│   └── Info.plist                    # Extension Konfiguration (com.apple.widgetkit-extension)
│
├── MinimalistApp/                    # Begleit-App mit Abfang-Routine
│   ├── MinimalistApp.swift           # App Einstiegspunkt
│   ├── ContentView.swift             # Live-Vorschau, interaktiver Slot-Picker & Deep Link Tester
│   ├── MindfulPauseView.swift        # Vollflächiger 10-Sekunden Zwischenscreen
│   ├── InterventionManager.swift     # Zentrales Handling der Abfang-Routine & onOpenURL
│   └── Info.plist                    # Enthält CFBundleURLTypes (minimalist://) & Schemes
│
├── MinimalistWidget.xcodeproj/       # Xcode-Projektdatei
│   └── project.pbxproj
│
└── README.md                         # Diese Dokumentation
```

---

## ⏳ Wie die Abfang-Routine funktioniert

```text
[ Nutzer tippt auf Social-Media-App ]
                  │
                  ▼
        Ist App zeitfressend?
         /                 \
       JA                   NEIN
       /                     \
minimalist://intervene        Direkter App-Start (z.B. tel://, calshow://)
       │
       ▼
[ Haupt-App öffnet MindfulPauseView ]
  - Schwarzer Hintergrund
  - 10-Sekunden animierter Countdown-Ring
  - "Nimm dir einen Moment Zeit. Musst du diese App jetzt wirklich öffnen?"
       │
       ├─────────────────────────────────┐
       ▼                                 ▼
   "Abbrechen"                       "Weiter"
(Screen schließt sich,           (Erst nach 10 Sek. aktivierbar,
 Ziel-App bleibt ZU)              öffnet dann erst die Ziel-App)
```

---

## ⚙️ Unterstützte Apps & Deep Link Enum (`SystemApp`)

| Enum Case | Anzeigename | Deep Link | Verhalten |
|---|---|---|---|
| `.phone` | **Telefon** | `tel://` | Direktes Öffnen |
| `.messages` | **Nachrichten** | `messages://` | Direktes Öffnen |
| `.facetime` | **FaceTime** | `facetime://` | Direktes Öffnen |
| `.calendar` | **Kalender** | `calshow://` | Direktes Öffnen |
| `.camera` | **Kamera** | `camera://` | Direktes Öffnen |
| `.notes` | **Notizen** | `mobilenotes://` | Direktes Öffnen |
| `.photos` | **Fotos** | `photos-redirect://` | Direktes Öffnen |
| `.mail` | **Mail** | `message://` | Direktes Öffnen |
| `.maps` | **Karten** | `maps://` | Direktes Öffnen |
| `.music` | **Musik** | `music://` | Direktes Öffnen |
| `.reminders` | **Erinnerungen** | `x-apple-reminderkit://` | Direktes Öffnen |
| `.settings` | **Einstellungen** | `app-prefs://` | Direktes Öffnen |
| `.clock` | **Uhr** | `clock-alarm://` | Direktes Öffnen |
| `.shortcuts` | **Kurzbefehle** | `shortcuts://` | Direktes Öffnen |
| `.safari` | **Safari** | `https://www.apple.com` | Direktes Öffnen |
| `.instagram` | **Instagram** | `instagram://` | ⏳ **10-Sekunden-Achtsamkeitspause** |
| `.tiktok` | **TikTok** | `tiktok://` | ⏳ **10-Sekunden-Achtsamkeitspause** |
| `.youtube` | **YouTube** | `youtube://` | ⏳ **10-Sekunden-Achtsamkeitspause** |
| `.twitter` | **X / Twitter** | `x://` | ⏳ **10-Sekunden-Achtsamkeitspause** |
| `.reddit` | **Reddit** | `reddit://` | ⏳ **10-Sekunden-Achtsamkeitspause** |

---

## 🛠️ Homescreen-Einrichtung auf dem iPhone

1. Auf dem iPhone-Homescreen eine freie Stelle gedrückt halten.
2. Oben links auf das **Plus-Zeichen (+)** tippen.
3. Nach **Minimalist** suchen und die **Large-Größe (.systemLarge)** wählen.
4. Auf das platzierte Widget lange tippen und **„Widget bearbeiten“** auswählen.
5. Slots 1 bis 5 nach Wunsch belegen. Das Widget aktualisiert sich sofort.
6. Beim Antippen von Social Media Apps wird automatisch die 10-Sekunden-Achtsamkeitspause vorgeschaltet!
