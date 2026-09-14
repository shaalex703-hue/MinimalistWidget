# MinimalistWidget – iOS WidgetKit Target (.systemLarge)

Ein minimalistisches, monochromes iOS WidgetKit-Widget im eleganten Schwarz-Weiß-Look mit dezenter Datums- und Uhrzeitanzeige sowie 5 editierbaren Favoriten-Apps, die sich per Fingertipp über benutzerdefinierte Deep Links direkt öffnen.

Inklusive einer integrierten **Achtsamkeits-Abfang-Routine** für zeitfressende Social-Media-Apps (z. B. Instagram, TikTok, YouTube, X, Reddit).

---

## 📱 Features

- **Widget-Größe**: Ausschließlich `.systemLarge` (`.supportedFamilies([.systemLarge])`).
- **Monochromes Design**:
  - Hintergrund: Reines Schwarz (`Color.black` / `.containerBackground(Color.black, for: .widget)`).
  - Typografie Favoriten-Liste: Reiner weißer Text mit `Font.system(size: 18, weight: .light, design: .default)`.
  - Layout-Abstand: Exakt `VStack(alignment: .leading, spacing: 18)`.
- **Header-Bereich**: Dezente Anzeige von Wochentag, Datum (z. B. *Montag, 14. September*) und aktueller Uhrzeit (z. B. *12:24*).
- **Interaktive App-Links**: Jeder Eintrag ist mit `Link(destination: app.widgetDestinationURL)` hinterlegt.
- **SelectFavoritesIntent (WidgetConfigurationIntent)**:
  - Nutzer können das Widget auf dem Home-Bildschirm gedrückt halten und unter **„Widget bearbeiten“** für die Slots 1 bis 5 beliebige System-Apps aus einem Dropdown-Menü auswählen.
  - Sofortige Widget-Aktualisierung bei jeder Änderung.
- **Abfang-Routine für Social-Media & zeitfressende Apps**:
  - Wird eine Social-Media-App (z. B. Instagram, TikTok, YouTube, X, Reddit) im Widget oder in der App angetippt, öffnet sich sofort ein vollflächiger schwarzer Zwischenscreen in der Haupt-App.
  - Ein 10-Sekunden Countdown-Kreis mit Textzähler läuft ab:
    > *„Nimm dir einen Moment Zeit. Musst du diese App jetzt wirklich öffnen?“*
  - **„Abbrechen“**: Schließt den Screen direkt, die App wird nicht geöffnet.
  - **„Weiter“**: Bleibt während des Countdowns inaktiv/ausgegraut und lässt sich erst nach Ablauf der 10 Sekunden aktivieren, um die Ziel-App zu öffnen.

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
