//
//  MinimalistWidgetView.swift
//  MinimalistWidget
//

import SwiftUI
import WidgetKit

/// Die Hauptansicht des MinimalistWidget in .systemLarge
public struct MinimalistWidgetView: View {
    public let date: Date
    public let favorites: [FavoriteApp]
    
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
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: - Oberer Bereich: Dezente Uhrzeit- & Datumsanzeige
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(Color.white.opacity(0.65))
                    .textCase(.none)
                
                Text(formattedTime)
                    .font(.system(size: 40, weight: .ultraLight, design: .default))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 26)
            
            // MARK: - Liste der 5 editierbaren Favoriten-Apps
            VStack(alignment: .leading, spacing: 18) {
                ForEach(favorites.prefix(5)) { app in
                    Link(destination: app.widgetDestinationURL) {
                        Text(app.name)
                            .font(.system(size: 18, weight: .light, design: .default))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(EdgeInsets(top: 28, leading: 24, bottom: 24, trailing: 24))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .widgetBackground(Color.black)
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

// MARK: - SwiftUI Preview
#Preview(as: .systemLarge) {
    MinimalistWidget()
} timeline: {
    MinimalistEntry(date: .now, favorites: FavoriteApp.defaultFavorites)
}
