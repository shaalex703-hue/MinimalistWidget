//
//  MinimalistQuoteWidget.swift
//  MinimalistWidget
//

import WidgetKit
import SwiftUI

// MARK: - Entry für das Quote-Widget
public struct MinimalistQuoteEntry: TimelineEntry {
    public let date: Date
    public let quote: String
    
    public init(date: Date, quote: String) {
        self.date = date
        self.quote = quote
    }
}

// MARK: - Standard Timeline Provider für das Quote-Widget (100% Sideloadly & iOS 16/17/18 kompatibel)
public struct MinimalistQuoteTimelineProvider: TimelineProvider {
    public typealias Entry = MinimalistQuoteEntry
    
    public init() {}
    
    public func placeholder(in context: Context) -> MinimalistQuoteEntry {
        MinimalistQuoteEntry(date: Date(), quote: MindfulQuote.defaultQuotes[0].text)
    }
    
    public func getSnapshot(in context: Context, completion: @escaping (MinimalistQuoteEntry) -> Void) {
        completion(MinimalistQuoteEntry(date: Date(), quote: MindfulQuote.quoteForToday().text))
    }
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<MinimalistQuoteEntry>) -> Void) {
        let currentDate = Date()
        let quote = MindfulQuote.quoteForToday().text
        let calendar = Calendar.current
        
        var entries: [MinimalistQuoteEntry] = []
        for minuteOffset in 0..<60 {
            if let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: currentDate) {
                entries.append(MinimalistQuoteEntry(date: entryDate, quote: quote))
            }
        }
        
        let nextUpdate = calendar.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate.addingTimeInterval(3600)
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Widget-Deklaration (StaticConfiguration)
public struct MinimalistQuoteWidget: Widget {
    public static let kind: String = "MinimalistQuoteWidget"
    
    public init() {}
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: Self.kind,
            provider: MinimalistQuoteTimelineProvider()
        ) { entry in
            MinimalistQuoteWidgetView(date: entry.date, quote: entry.quote)
        }
        .configurationDisplayName("Minimalist Zitat & Zeit")
        .description("Dezente Zeitanzeige und tägliche Achtsamkeits-Impulse.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}
