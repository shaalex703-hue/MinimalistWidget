//
//  MinimalistWidgetView.swift
//  MinimalistWidget
//

import SwiftUI
import WidgetKit

/// Die Hauptansicht des Minimalist Launcher Widgets für .systemLarge, .systemMedium und .systemSmall
public struct MinimalistWidgetView: View {
    public let date: Date
    public let favorites: [FavoriteApp]
    
    @Environment(\.widgetFamily) private var family
    
    public init(date: Date, favorites: [FavoriteApp] = FavoriteApp.defaultFavorites) {
        self.date = date
        self.favorites = favorites
    }
    
    // MARK: - Formatierer für Datum und Uhrzeit
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "EEEE, d. MMMM"
        return formatter.string(from: date)
    }
    
    private var formattedShortDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "d. MMM"
        return formatter.string(from: date)
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    public var body: some View {
        Group {
            switch family {
            case .systemLarge:
                largeWidgetView
            case .systemMedium:
                mediumWidgetView
            case .systemSmall:
                smallWidgetView
            @unknown default:
                largeWidgetView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .widgetBackground(Color.black)
    }
    
    // MARK: - Große Ansicht (.systemLarge) - Bis zu 6 Apps + Kopfbereich
    private var largeWidgetView: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header: Uhrzeit & Datum
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(Color.white.opacity(0.65))
                
                Text(formattedTime)
                    .font(.system(size: 40, weight: .ultraLight, design: .default))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 22)
            
            // Liste der Favoriten-Apps (VStack spacing: 16)
            VStack(alignment: .leading, spacing: 16) {
                ForEach(favorites.prefix(6)) { app in
                    appRow(app, fontSize: 17)
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(EdgeInsets(top: 26, leading: 22, bottom: 22, trailing: 22))
    }
    
    // MARK: - Mittlere Ansicht (.systemMedium) - 4 Apps in 2 Spalten oder Zeit + 3 Apps
    private var mediumWidgetView: some View {
        HStack(alignment: .center, spacing: 20) {
            // Linke Spalte: Zeit & Datum
            VStack(alignment: .leading, spacing: 2) {
                Text(formattedShortDate)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.white.opacity(0.65))
                
                Text(formattedTime)
                    .font(.system(size: 32, weight: .ultraLight))
                    .foregroundColor(.white)
                
                Spacer(minLength: 0)
            }
            .frame(width: 80, alignment: .leading)
            
            Divider()
                .background(Color.white.opacity(0.12))
            
            // Rechte Spalte: 3 bis 4 Apps
            VStack(alignment: .leading, spacing: 14) {
                ForEach(favorites.prefix(3)) { app in
                    appRow(app, fontSize: 16)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
    }
    
    // MARK: - Kleine Ansicht (.systemSmall) - 3 Schnellzugriff-Apps
    private var smallWidgetView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(formattedTime)
                .font(.system(size: 18, weight: .light))
                .foregroundColor(Color.white.opacity(0.6))
                .padding(.bottom, 2)
            
            ForEach(favorites.prefix(3)) { app in
                appRow(app, fontSize: 16)
            }
            
            Spacer(minLength: 0)
        }
        .padding(EdgeInsets(top: 18, leading: 16, bottom: 16, trailing: 16))
    }
    
    // MARK: - Zeile für eine App mit Link
    private func appRow(_ app: FavoriteApp, fontSize: CGFloat = 18) -> some View {
        Link(destination: app.widgetDestinationURL) {
            Text(app.name)
                .font(.system(size: fontSize, weight: .light, design: .default))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
        }
    }
}

// MARK: - ViewModifier für saubere Hintergrundfarbe (iOS 17+ & Abwärtskompatibilität)
extension View {
    @ViewBuilder
    public func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOS 17.0, *) {
            self.containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            self.background(backgroundView)
        }
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

