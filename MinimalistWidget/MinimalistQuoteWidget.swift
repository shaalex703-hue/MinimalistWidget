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

// MARK: - View für das Quote-Widget (.systemSmall & .systemMedium)
public struct MinimalistQuoteWidgetView: View {
    public let date: Date
    public let quote: String
    
    @Environment(\.widgetFamily) private var family
    
    public init(date: Date, quote: String) {
        self.date = date
        self.quote = quote
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "EEEE, d. MMMM"
        return formatter.string(from: date)
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Oberer Bereich: Uhrzeit & Datum
            VStack(alignment: .leading, spacing: 2) {
                Text(formattedDate)
                    .font(.system(size: family == .systemSmall ? 11 : 13, weight: .regular))
                    .foregroundColor(Color.white.opacity(0.6))
                
                Text(formattedTime)
                    .font(.system(size: family == .systemSmall ? 28 : 36, weight: .ultraLight))
                    .foregroundColor(.white)
            }
            
            Spacer(minLength: 8)
            
            // Achtsamkeits-Zitat / Fokus-Impuls
            Text(quote)
                .font(.system(size: family == .systemSmall ? 13 : 15, weight: .light, design: .serif))
                .italic()
                .foregroundColor(Color.white.opacity(0.85))
                .lineLimit(family == .systemSmall ? 3 : 2)
                .lineSpacing(3)
        }
        .padding(family == .systemSmall ? 16 : 22)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .widgetBackground(Color.black)
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
