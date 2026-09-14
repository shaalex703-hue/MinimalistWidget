//
//  FavoriteApp.swift
//  MinimalistWidget
//

import Foundation
import AppIntents

/// Modell für eine im Widget angezeigte Favoriten-App
public struct FavoriteApp: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public var name: String
    public var urlScheme: String
    
    public init(id: String = UUID().uuidString, name: String, urlScheme: String) {
        self.id = id
        self.name = name
        self.urlScheme = urlScheme
    }
    
    /// Sichere URL-Auflösung mit Fallback
    public var url: URL {
        if let parsed = URL(string: urlScheme) {
            return parsed
        }
        return URL(string: "about:blank")!
    }
    
    /// Liefert die Link-Ziel-URL für das Widget.
    /// Zeitfressende Social-Media-Apps werden über 'minimalist://intervene?...' zur Achtsamkeits-Pause umgeleitet.
    public var widgetDestinationURL: URL {
        TimeWastingApps.destinationURL(for: name, rawScheme: urlScheme)
    }
    
    // MARK: - Standard-Favoriten (die 6 wichtigsten Apps inkl. Social Media Achtsamkeit)
    public static let defaultFavorites: [FavoriteApp] = [
        FavoriteApp(id: "phone", name: "Telefon", urlScheme: "tel://"),
        FavoriteApp(id: "messages", name: "Nachrichten", urlScheme: "messages://"),
        FavoriteApp(id: "whatsapp", name: "WhatsApp", urlScheme: "whatsapp://"),
        FavoriteApp(id: "spotify", name: "Spotify", urlScheme: "spotify://"),
        FavoriteApp(id: "notes", name: "Notizen", urlScheme: "mobilenotes://"),
        FavoriteApp(id: "instagram", name: "Instagram", urlScheme: "instagram://")
    ]
    
    // MARK: - Katalog beliebter iOS URL-Schemes
    public static let presetCatalog: [FavoriteApp] = [
        FavoriteApp(id: "phone", name: "Telefon", urlScheme: "tel://"),
        FavoriteApp(id: "messages", name: "Nachrichten", urlScheme: "messages://"),
        FavoriteApp(id: "camera", name: "Kamera", urlScheme: "camera://"),
        FavoriteApp(id: "notes", name: "Notizen", urlScheme: "mobilenotes://"),
        FavoriteApp(id: "calendar", name: "Kalender", urlScheme: "calshow://"),
        FavoriteApp(id: "mail", name: "Mail", urlScheme: "message://"),
        FavoriteApp(id: "photos", name: "Fotos", urlScheme: "photos-redirect://"),
        FavoriteApp(id: "maps", name: "Karten", urlScheme: "maps://"),
        FavoriteApp(id: "music", name: "Musik", urlScheme: "music://"),
        FavoriteApp(id: "settings", name: "Einstellungen", urlScheme: "app-prefs://"),
        FavoriteApp(id: "reminders", name: "Erinnerungen", urlScheme: "x-apple-reminderkit://"),
        FavoriteApp(id: "safari", name: "Safari", urlScheme: "https://www.apple.com"),
        FavoriteApp(id: "whatsapp", name: "WhatsApp", urlScheme: "whatsapp://"),
        FavoriteApp(id: "spotify", name: "Spotify", urlScheme: "spotify://"),
        FavoriteApp(id: "instagram", name: "Instagram", urlScheme: "instagram://"),
        FavoriteApp(id: "tiktok", name: "TikTok", urlScheme: "tiktok://"),
        FavoriteApp(id: "youtube", name: "YouTube", urlScheme: "youtube://"),
        FavoriteApp(id: "twitter", name: "X / Twitter", urlScheme: "x://"),
        FavoriteApp(id: "reddit", name: "Reddit", urlScheme: "reddit://"),
        FavoriteApp(id: "snapchat", name: "Snapchat", urlScheme: "snapchat://"),
        FavoriteApp(id: "threads", name: "Threads", urlScheme: "threads://")
    ]
}

// MARK: - AppEntity Conformance für WidgetKit AppIntents
@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
public struct AppEntityItem: AppEntity {
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Favoriten-App"
    public static var defaultQuery = AppEntityItemQuery()
    
    public var id: String
    public var name: String
    public var urlScheme: String
    
    public init(id: String, name: String, urlScheme: String) {
        self.id = id
        self.name = name
        self.urlScheme = urlScheme
    }
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)", subtitle: "\(urlScheme)")
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
public struct AppEntityItemQuery: EntityQuery {
    public init() {}
    
    public func entities(for identifiers: [String]) async throws -> [AppEntityItem] {
        return FavoriteApp.presetCatalog
            .filter { identifiers.contains($0.id) }
            .map { AppEntityItem(id: $0.id, name: $0.name, urlScheme: $0.urlScheme) }
    }
    
    public func suggestedEntities() async throws -> [AppEntityItem] {
        return FavoriteApp.presetCatalog
            .map { AppEntityItem(id: $0.id, name: $0.name, urlScheme: $0.urlScheme) }
    }
    
    public func defaultResult() async -> AppEntityItem? {
        if let first = FavoriteApp.presetCatalog.first {
            return AppEntityItem(id: first.id, name: first.name, urlScheme: first.urlScheme)
        }
        return nil
    }
}
