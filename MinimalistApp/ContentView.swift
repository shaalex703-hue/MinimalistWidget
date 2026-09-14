//
//  ContentView.swift
//  MinimalistApp
//

import SwiftUI

enum PreviewWidgetType: String, CaseIterable, Identifiable {
    case launcherLarge = "Launcher Groß"
    case launcherMedium = "Launcher Mittel"
    case launcherSmall = "Launcher Klein"
    case quoteMedium = "Zitat Mittel"
    case quoteSmall = "Zitat Klein"
    
    var id: String { rawValue }
}

struct ContentView: View {
    // 6 konfigurierbare Slots (entspricht SelectFavoritesIntent)
    @State private var slot1: SystemApp = .phone
    @State private var slot2: SystemApp = .messages
    @State private var slot3: SystemApp = .whatsapp
    @State private var slot4: SystemApp = .spotify
    @State private var slot5: SystemApp = .notes
    @State private var slot6: SystemApp = .instagram
    
    @State private var selectedPreviewType: PreviewWidgetType = .launcherLarge
    @State private var selectedQuote: String = MindfulQuote.quoteForToday().text
    @State private var isBlackWallpaperSaved = false
    
    @StateObject private var interventionManager = InterventionManager.shared
    @Environment(\.openURL) private var openURL
    @State private var activeAlertMessage: String?
    
    // Dynamische Favoritenliste basierend auf den Slots
    private var currentFavorites: [FavoriteApp] {
        [
            slot1.asFavoriteApp,
            slot2.asFavoriteApp,
            slot3.asFavoriteApp,
            slot4.asFavoriteApp,
            slot5.asFavoriteApp,
            slot6.asFavoriteApp
        ]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // MARK: - Banner für aktive Abfang-Routine
                    HStack(spacing: 12) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Achtsamkeits-Pause Aktiv")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            Text("Social-Media-Apps werden vor dem Start 10 Sek. abgefangen.")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(14)
                    .background(Color(white: 0.08))
                    .cornerRadius(14)

                    // MARK: - 4-Schritte Anleitung zum Minimalist Phone
                    VStack(alignment: .leading, spacing: 14) {
                        Text("DEIN IPHONE ZUM MINIMALIST PHONE MACHEN")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 10) {
                            setupStepRow(
                                number: "1",
                                title: "Schwarzen Hintergrund setzen",
                                desc: "Reines Schwarz (#000000) lässt die Widgets nahtlos mit dem OLED-Display verschmelzen."
                            )
                            setupStepRow(
                                number: "2",
                                title: "Icons vom Home-Bildschirm entfernen",
                                desc: "Apps gedrückt halten ➔ 'Vom Home-Bildschirm entfernen'. Sie bleiben in der Mediathek verfügbar."
                            )
                            setupStepRow(
                                number: "3",
                                title: "Minimalist Widgets platzieren",
                                desc: "Homescreen gedrückt halten ➔ '+' ➔ 'Minimalist' wählen ➔ Großes Launcher- & Zitat-Widget ablegen."
                            )
                            setupStepRow(
                                number: "4",
                                title: "Alles läuft über Widgets & Achtsamkeit",
                                desc: "Öffne Apps direkt per Text-Tap. Social Media wird automatisch für 10 Sekunden entschleunigt."
                            )
                        }
                        .padding(14)
                        .background(Color(white: 0.08))
                        .cornerRadius(14)
                    }
                    
                    // MARK: - Live Vorschau aller Widgets
                    VStack(alignment: .leading, spacing: 12) {
                        Text("LIVE WIDGET-VORSCHAU")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        // Segmented Picker für Widget-Typen
                        Picker("Widget-Typ", selection: $selectedPreviewType) {
                            ForEach(PreviewWidgetType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        // Widget-Rahmen
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                                )
                            
                            Group {
                                switch selectedPreviewType {
                                case .launcherLarge:
                                    MinimalistWidgetView(date: Date(), favorites: currentFavorites, family: .systemLarge)
                                        .frame(height: 330)
                                case .launcherMedium:
                                    MinimalistWidgetView(date: Date(), favorites: currentFavorites, family: .systemMedium)
                                        .frame(height: 160)
                                case .launcherSmall:
                                    MinimalistWidgetView(date: Date(), favorites: currentFavorites, family: .systemSmall)
                                        .frame(width: 160, height: 160)
                                case .quoteMedium:
                                    MinimalistQuoteWidgetView(date: Date(), quote: selectedQuote, family: .systemMedium)
                                        .frame(height: 160)
                                case .quoteSmall:
                                    MinimalistQuoteWidgetView(date: Date(), quote: selectedQuote, family: .systemSmall)
                                        .frame(width: 160, height: 160)
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                    }
                    
                    // MARK: - Fokus-Zitate & Achtsamkeit
                    VStack(alignment: .leading, spacing: 14) {
                        Text("ACHTSAMKEITS-ZITATE FÜR DEIN PHONE")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 8) {
                            ForEach(MindfulQuote.defaultQuotes) { quote in
                                HStack {
                                    Text(quote.text)
                                        .font(.system(size: 14, weight: quote.text == selectedQuote ? .medium : .light))
                                        .foregroundColor(quote.text == selectedQuote ? .white : Color.white.opacity(0.7))
                                    
                                    Spacer()
                                    
                                    if quote.text == selectedQuote {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 14))
                                    }
                                }
                                .padding(12)
                                .background(quote.text == selectedQuote ? Color.white.opacity(0.12) : Color(white: 0.08))
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedQuote = quote.text
                                }
                            }
                        }
                    }
                    
                    // MARK: - Schnelltest der Abfang-Routine
                    VStack(alignment: .leading, spacing: 14) {
                        Text("ABFANG-ROUTINE TESTEN")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 10) {
                            socialMediaTestRow(name: "Instagram", scheme: "instagram://")
                            socialMediaTestRow(name: "TikTok", scheme: "tiktok://")
                            socialMediaTestRow(name: "YouTube", scheme: "youtube://")
                            socialMediaTestRow(name: "X / Twitter", scheme: "x://")
                            socialMediaTestRow(name: "Reddit", scheme: "reddit://")
                        }
                    }
                    
                    // MARK: - Slot-Konfiguration
                    VStack(alignment: .leading, spacing: 14) {
                        Text("FAVORITEN-SLOTS KONFIGURIEREN")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 8) {
                            slotPickerRow(title: "Slot 1", selection: $slot1)
                            slotPickerRow(title: "Slot 2", selection: $slot2)
                            slotPickerRow(title: "Slot 3", selection: $slot3)
                            slotPickerRow(title: "Slot 4", selection: $slot4)
                            slotPickerRow(title: "Slot 5", selection: $slot5)
                            slotPickerRow(title: "Slot 6", selection: $slot6)
                        }
                        .padding(14)
                        .background(Color(white: 0.08))
                        .cornerRadius(14)
                    }
                    
                    // MARK: - Tiefschwarzes Wallpaper Tool
                    VStack(alignment: .leading, spacing: 12) {
                        Text("TIEFSCHWARZES WALLPAPER")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Reines Schwarz (#000000)")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white)
                                Text("Lässt deine Widgets nahtlos mit dem iPhone-Display verschmelzen.")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            
                            Button(action: {
                                activeAlertMessage = "Tipp: Öffne dein iPhone-Fotoalbum oder wähle in Einstellungen ➔ Hintergrundbild einfach die reine schwarze Farboption aus!"
                            }) {
                                Text("Info")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(16)
                        .background(Color(white: 0.08))
                        .cornerRadius(14)
                    }
                }
                .padding(20)
            }
            .background(Color(white: 0.03).ignoresSafeArea())
            .navigationTitle("Minimalist Phone")
            .onOpenURL { incomingURL in
                interventionManager.handleIncomingURL(incomingURL)
            }
            .fullScreenCover(isPresented: $interventionManager.isInterventionActive) {
                MindfulPauseView(
                    targetAppName: interventionManager.targetAppName,
                    targetURL: interventionManager.targetURL,
                    onDismiss: {
                        interventionManager.dismiss()
                    }
                )
            }
            .alert("Hinweis", isPresented: Binding(
                get: { activeAlertMessage != nil },
                set: { if !$0 { activeAlertMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(activeAlertMessage ?? "")
            }
        }
    }
    
    private func setupStepRow(number: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .frame(width: 22, height: 22)
                .background(Color.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.6))
                    .lineSpacing(2)
            }
            Spacer()
        }
        .padding(.vertical, 2)
    }

    private func socialMediaTestRow(name: String, scheme: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                Text(scheme)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                if let url = URL(string: scheme) {
                    interventionManager.triggerIntervention(appName: name, targetURL: url)
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "hourglass")
                        .font(.system(size: 12))
                    Text("10s Pause")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(Capsule())
            }
        }
        .padding(12)
        .background(Color(white: 0.08))
        .cornerRadius(12)
    }
    
    private func slotPickerRow(title: String, selection: Binding<SystemApp>) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            Picker(title, selection: selection) {
                ForEach(SystemApp.allCases, id: \.self) { app in
                    Text("\(app.displayName) (\(app.deepLinkString))")
                        .tag(app)
                }
            }
            .tint(.white)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
