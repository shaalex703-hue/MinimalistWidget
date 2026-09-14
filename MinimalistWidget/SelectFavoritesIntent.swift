//
//  SelectFavoritesIntent.swift
//  MinimalistWidget
//

import WidgetKit
import AppIntents
import SwiftUI

// MARK: - Enum aller gängigen System-Apps und Deep Links
@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
public enum SystemApp: String, CaseIterable, AppEnum, Sendable {
    case phone = "phone"
    case messages = "messages"
    case facetime = "facetime"
    case calendar = "calendar"
    case camera = "camera"
    case notes = "notes"
    case photos = "photos"
    case mail = "mail"
    case maps = "maps"
    case music = "music"
    case reminders = "reminders"
    case settings = "settings"
    case clock = "clock"
    case shortcuts = "shortcuts"
    case safari = "safari"
    case weather = "weather"
    case files = "files"
    case appStore = "appStore"
    case health = "health"
    case wallet = "wallet"
    case instagram = "instagram"
    case tiktok = "tiktok"
    case youtube = "youtube"
    case twitter = "twitter"
    case reddit = "reddit"

    // MARK: - AppEnum Repräsentation
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "System-App"

    public static var caseDisplayRepresentations: [SystemApp: DisplayRepresentation] = [
        .phone: DisplayRepresentation(title: "Telefon", subtitle: "tel://"),
        .messages: DisplayRepresentation(title: "Nachrichten", subtitle: "messages://"),
        .facetime: DisplayRepresentation(title: "FaceTime", subtitle: "facetime://"),
        .calendar: DisplayRepresentation(title: "Kalender", subtitle: "calshow://"),
        .camera: DisplayRepresentation(title: "Kamera", subtitle: "camera://"),
        .notes: DisplayRepresentation(title: "Notizen", subtitle: "mobilenotes://"),
        .photos: DisplayRepresentation(title: "Fotos", subtitle: "photos-redirect://"),
        .mail: DisplayRepresentation(title: "Mail", subtitle: "message://"),
        .maps: DisplayRepresentation(title: "Karten", subtitle: "maps://"),
        .music: DisplayRepresentation(title: "Musik", subtitle: "music://"),
        .reminders: DisplayRepresentation(title: "Erinnerungen", subtitle: "x-apple-reminderkit://"),
        .settings: DisplayRepresentation(title: "Einstellungen", subtitle: "app-prefs://"),
        .clock: DisplayRepresentation(title: "Uhr", subtitle: "clock-alarm://"),
        .shortcuts: DisplayRepresentation(title: "Kurzbefehle", subtitle: "shortcuts://"),
        .safari: DisplayRepresentation(title: "Safari", subtitle: "https://www.apple.com"),
        .weather: DisplayRepresentation(title: "Wetter", subtitle: "weather://"),
        .files: DisplayRepresentation(title: "Dateien", subtitle: "shareddocuments://"),
        .appStore: DisplayRepresentation(title: "App Store", subtitle: "itms-apps://"),
        .health: DisplayRepresentation(title: "Health", subtitle: "x-apple-health://"),
        .wallet: DisplayRepresentation(title: "Wallet", subtitle: "shoebox://"),
        .instagram: DisplayRepresentation(title: "Instagram", subtitle: "instagram:// (Mit Pause)"),
        .tiktok: DisplayRepresentation(title: "TikTok", subtitle: "tiktok:// (Mit Pause)"),
        .youtube: DisplayRepresentation(title: "YouTube", subtitle: "youtube:// (Mit Pause)"),
        .twitter: DisplayRepresentation(title: "X / Twitter", subtitle: "x:// (Mit Pause)"),
        .reddit: DisplayRepresentation(title: "Reddit", subtitle: "reddit:// (Mit Pause)")
    ]

    // MARK: - Lesbarer Anzeigename
    public var displayName: String {
        switch self {
        case .phone: return "Telefon"
        case .messages: return "Nachrichten"
        case .facetime: return "FaceTime"
        case .calendar: return "Kalender"
        case .camera: return "Kamera"
        case .notes: return "Notizen"
        case .photos: return "Fotos"
        case .mail: return "Mail"
        case .maps: return "Karten"
        case .music: return "Musik"
        case .reminders: return "Erinnerungen"
        case .settings: return "Einstellungen"
        case .clock: return "Uhr"
        case .shortcuts: return "Kurzbefehle"
        case .safari: return "Safari"
        case .weather: return "Wetter"
        case .files: return "Dateien"
        case .appStore: return "App Store"
        case .health: return "Health"
        case .wallet: return "Wallet"
        case .instagram: return "Instagram"
        case .tiktok: return "TikTok"
        case .youtube: return "YouTube"
        case .twitter: return "X / Twitter"
        case .reddit: return "Reddit"
        }
    }

    // MARK: - Zugehöriges Deep Link URL-Scheme
    public var deepLinkString: String {
        switch self {
        case .phone: return "tel://"
        case .messages: return "messages://"
        case .facetime: return "facetime://"
        case .calendar: return "calshow://"
        case .camera: return "camera://"
        case .notes: return "mobilenotes://"
        case .photos: return "photos-redirect://"
        case .mail: return "message://"
        case .maps: return "maps://"
        case .music: return "music://"
        case .reminders: return "x-apple-reminderkit://"
        case .settings: return "app-prefs://"
        case .clock: return "clock-alarm://"
        case .shortcuts: return "shortcuts://"
        case .safari: return "https://www.apple.com"
        case .weather: return "weather://"
        case .files: return "shareddocuments://"
        case .appStore: return "itms-apps://"
        case .health: return "x-apple-health://"
        case .wallet: return "shoebox://"
        case .instagram: return "instagram://"
        case .tiktok: return "tiktok://"
        case .youtube: return "youtube://"
        case .twitter: return "x://"
        case .reddit: return "reddit://"
        }
    }

    public var deepLinkURL: URL {
        URL(string: deepLinkString) ?? URL(string: "about:blank")!
    }

    /// Konvertiert dieses Enum in das FavoriteApp Datenmodell
    public var asFavoriteApp: FavoriteApp {
        FavoriteApp(id: rawValue, name: displayName, urlScheme: deepLinkString)
    }
}

// MARK: - SelectFavoritesIntent für Home-Screen "Widget bearbeiten"
@available(iOS 17.0, *)
public struct SelectFavoritesIntent: WidgetConfigurationIntent {
    public static var title: LocalizedStringResource = "Favoriten auswählen"
    public static var description: IntentDescription = IntentDescription("Wähle die Apps für die 5 Favoriten-Slots deines Widgets.")

    @Parameter(title: "Slot 1", default: .phone)
    public var slot1: SystemApp

    @Parameter(title: "Slot 2", default: .messages)
    public var slot2: SystemApp

    @Parameter(title: "Slot 3", default: .camera)
    public var slot3: SystemApp

    @Parameter(title: "Slot 4", default: .notes)
    public var slot4: SystemApp

    @Parameter(title: "Slot 5", default: .calendar)
    public var slot5: SystemApp

    public init() {
        self.slot1 = .phone
        self.slot2 = .messages
        self.slot3 = .camera
        self.slot4 = .notes
        self.slot5 = .calendar
    }

    public init(slot1: SystemApp, slot2: SystemApp, slot3: SystemApp, slot4: SystemApp, slot5: SystemApp) {
        self.slot1 = slot1
        self.slot2 = slot2
        self.slot3 = slot3
        self.slot4 = slot4
        self.slot5 = slot5
    }

    /// Löst die 5 ausgewählten Apps als Array auf
    public func resolveFavorites() -> [FavoriteApp] {
        return [
            slot1.asFavoriteApp,
            slot2.asFavoriteApp,
            slot3.asFavoriteApp,
            slot4.asFavoriteApp,
            slot5.asFavoriteApp
        ]
    }
}

// Abwärtskompatibler Typalias
@available(iOS 17.0, *)
public typealias ConfigurationAppIntent = SelectFavoritesIntent
