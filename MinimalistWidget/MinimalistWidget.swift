//
//  MinimalistWidget.swift
//  MinimalistWidget
//

import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Timeline Entry
public struct MinimalistEntry: TimelineEntry {
    public let date: Date
    public let favorites: [FavoriteApp]
    
    public init(date: Date, favorites: [FavoriteApp] = FavoriteApp.defaultFavorites) {
        self.date = date
        self.favorites = favorites
    }
}

// MARK: - AppIntent Timeline Provider (iOS 17+)
@available(iOS 17.0, *)
public struct SelectFavoritesTimelineProvider: AppIntentTimelineProvider {
    public typealias Entry = MinimalistEntry
    public typealias Intent = SelectFavoritesIntent
    
    public init() {}
    
    public func placeholder(in context: Context) -> MinimalistEntry {
        MinimalistEntry(date: Date(), favorites: FavoriteApp.defaultFavorites)
    }
    
    public func snapshot(for configuration: SelectFavoritesIntent, in context: Context) async -> MinimalistEntry {
        MinimalistEntry(date: Date(), favorites: configuration.resolveFavorites())
    }
    
    public func timeline(for configuration: SelectFavoritesIntent, in context: Context) async -> Timeline<MinimalistEntry> {
        let currentDate = Date()
        let favorites = configuration.resolveFavorites()
        let calendar = Calendar.current
        
        // Minütliche Einträge für präzise Zeitanzeige
        var entries: [MinimalistEntry] = []
        for minuteOffset in 0..<60 {
            if let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: currentDate) {
                entries.append(MinimalistEntry(date: entryDate, favorites: favorites))
            }
        }
        
        let nextUpdate = calendar.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate.addingTimeInterval(3600)
        return Timeline(entries: entries, policy: .after(nextUpdate))
    }
}

// MARK: - Widget Definition
public struct MinimalistWidget: Widget {
    public static let kind: String = "MinimalistWidget"
    
    public init() {}
    
    public var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: Self.kind,
            intent: SelectFavoritesIntent.self,
            provider: SelectFavoritesTimelineProvider()
        ) { entry in
            MinimalistWidgetView(date: entry.date, favorites: entry.favorites)
        }
        .configurationDisplayName("Minimalist Launcher")
        .description("Dezentes Dashboard mit Datum, Uhrzeit und wählbaren App-Favoriten.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}
