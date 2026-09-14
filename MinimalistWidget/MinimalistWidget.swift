//
//  MinimalistWidget.swift
//  MinimalistWidget
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
public struct MinimalistEntry: TimelineEntry {
    public let date: Date
    public let favorites: [FavoriteApp]
    
    public init(date: Date, favorites: [FavoriteApp] = FavoriteApp.defaultFavorites) {
        self.date = date
        self.favorites = favorites
    }
}

// MARK: - Standard Timeline Provider (100% Sideloadly & iOS 16/17/18 kompatibel)
public struct MinimalistTimelineProvider: TimelineProvider {
    public typealias Entry = MinimalistEntry
    
    public init() {}
    
    public func placeholder(in context: Context) -> MinimalistEntry {
        MinimalistEntry(date: Date(), favorites: FavoriteApp.defaultFavorites)
    }
    
    public func getSnapshot(in context: Context, completion: @escaping (MinimalistEntry) -> Void) {
        completion(MinimalistEntry(date: Date(), favorites: FavoriteApp.defaultFavorites))
    }
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<MinimalistEntry>) -> Void) {
        let currentDate = Date()
        let favorites = FavoriteApp.defaultFavorites
        let calendar = Calendar.current
        
        // Minütliche Einträge für eine exakte Zeitanzeige
        var entries: [MinimalistEntry] = []
        for minuteOffset in 0..<60 {
            if let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: currentDate) {
                entries.append(MinimalistEntry(date: entryDate, favorites: favorites))
            }
        }
        
        let nextUpdate = calendar.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate.addingTimeInterval(3600)
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Widget Definition (StaticConfiguration - unempfindlich gegen Bundle-ID-Mangling)
public struct MinimalistWidget: Widget {
    public static let kind: String = "MinimalistWidget"
    
    public init() {}
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: Self.kind,
            provider: MinimalistTimelineProvider()
        ) { entry in
            MinimalistWidgetView(date: entry.date, favorites: entry.favorites)
        }
        .configurationDisplayName("Minimalist Launcher")
        .description("Dezentes Dashboard mit Datum, Uhrzeit und schnellen App-Links.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}
