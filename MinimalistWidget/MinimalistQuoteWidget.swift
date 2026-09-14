//
//  MinimalistQuoteWidget.swift
//  MinimalistWidget
//

import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Entry für das Quote-Widget
public struct MinimalistQuoteEntry: TimelineEntry {
    public let date: Date
    public let quote: String
    
    public init(date: Date, quote: String) {
        self.date = date
        self.quote = quote
    }
}

// MARK: - TimelineProvider für das Quote-Widget
@available(iOS 17.0, *)
public struct MinimalistQuoteTimelineProvider: AppIntentTimelineProvider {
    public typealias Entry = MinimalistQuoteEntry
    public typealias Intent = SelectQuoteIntent
    
    public init() {}
    
    public func placeholder(in context: Context) -> MinimalistQuoteEntry {
        MinimalistQuoteEntry(date: Date(), quote: MindfulQuote.defaultQuotes[0].text)
    }
    
    public func snapshot(for configuration: SelectQuoteIntent, in context: Context) async -> MinimalistQuoteEntry {
        MinimalistQuoteEntry(date: Date(), quote: configuration.resolveQuote())
    }
    
    public func timeline(for configuration: SelectQuoteIntent, in context: Context) async -> Timeline<MinimalistQuoteEntry> {
        let currentDate = Date()
        let quote = configuration.resolveQuote()
        let calendar = Calendar.current
        
        var entries: [MinimalistQuoteEntry] = []
        for minuteOffset in 0..<60 {
            if let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: currentDate) {
                entries.append(MinimalistQuoteEntry(date: entryDate, quote: quote))
            }
        }
        
        let nextUpdate = calendar.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate.addingTimeInterval(3600)
        return Timeline(entries: entries, policy: .after(nextUpdate))
    }
}


// MARK: - Widget-Deklaration
@available(iOS 17.0, *)
public struct MinimalistQuoteWidget: Widget {
    public static let kind: String = "MinimalistQuoteWidget"
    
    public init() {}
    
    public var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: Self.kind,
            intent: SelectQuoteIntent.self,
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

#Preview {
    MinimalistQuoteWidgetView(date: Date(), quote: "Weniger Bildschirm, mehr Leben.")
        .frame(width: 320, height: 160)
        .background(Color.black)
}
