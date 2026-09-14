//
//  MindfulQuote.swift
//  MinimalistWidget
//

import Foundation
import AppIntents

/// Datenmodell für minimalistische Achtsamkeits- und Fokus-Zitate
public struct MindfulQuote: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public var text: String
    public var author: String?
    
    public init(id: String = UUID().uuidString, text: String, author: String? = nil) {
        self.id = id
        self.text = text
        self.author = author
    }
    
    /// Standardzitate für ein ablenkungsfreies Telefon
    public static let defaultQuotes: [MindfulQuote] = [
        MindfulQuote(id: "quote-1", text: "Weniger Bildschirm, mehr Leben."),
        MindfulQuote(id: "quote-2", text: "Sei im Hier und Jetzt präsent."),
        MindfulQuote(id: "quote-3", text: "Fokus auf das Wesentliche."),
        MindfulQuote(id: "quote-4", text: "Brauchst du diese App jetzt wirklich?"),
        MindfulQuote(id: "quote-5", text: "Atme durch und nimm dir Zeit."),
        MindfulQuote(id: "quote-6", text: "Qualität vor digitaler Quantität."),
        MindfulQuote(id: "quote-7", text: "Dein Tag gehört dir, nicht dem Feed."),
        MindfulQuote(id: "quote-8", text: "Stille ist der wahre Luxus.")
    ]
    
    /// Liefert das heutige Zitat basierend auf dem Kalendertag
    public static func quoteForToday() -> MindfulQuote {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayOfYear % defaultQuotes.count
        return defaultQuotes[index]
    }
}
