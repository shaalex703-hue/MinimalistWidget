//
//  ContentView.swift
//  MinimalistApp
//

import SwiftUI

struct ContentView: View {
    // 5 konfigurierbare Slots (entspricht SelectFavoritesIntent)
    @State private var slot1: SystemApp = .phone
    @State private var slot2: SystemApp = .messages
    @State private var slot3: SystemApp = .instagram
    @State private var slot4: SystemApp = .notes
    @State private var slot5: SystemApp = .calendar
    
    @StateObject private var interventionManager = InterventionManager.shared
    @Environment(\.openURL) private var openURL
    @State private var activeAlertMessage: String?
    
    // Dynamische Favoritenliste basierend auf den 5 Slots
    private var currentFavorites: [FavoriteApp] {
        [
            slot1.asFavoriteApp,
            slot2.asFavoriteApp,
            slot3.asFavoriteApp,
            slot4.asFavoriteApp,
            slot5.asFavoriteApp
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
                            Text("Social-Media-Apps werden vor dem Öffnen 10 Sek. abgefangen.")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(14)
                    .background(Color(white: 0.08))
                    .cornerRadius(14)
                    
                    // MARK: - Live Vorschau des Widgets
                    VStack(alignment: .leading, spacing: 12) {
                        Text("LIVE WIDGET-VORSCHAU (.systemLarge)")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                )
                            
                            MinimalistWidgetView(date: Date(), favorites: currentFavorites)
                                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        }
                        .frame(height: 350)
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
                    
                    // MARK: - Slot-Konfiguration (Simuliert "Widget bearbeiten")
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
                        }
                        .padding(14)
                        .background(Color(white: 0.08))
                        .cornerRadius(14)
                    }
                    
                    // MARK: - Deep Links der aktuellen Auswahl testen
                    VStack(alignment: .leading, spacing: 14) {
                        Text("DEEP LINKS DER AKTUELLEN AUSWAHL")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 10) {
                            ForEach(currentFavorites) { app in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack(spacing: 6) {
                                            Text(app.name)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.white)
                                            
                                            if TimeWastingApps.isTimeWasting(url: app.url) {
                                                Text("10s Pause")
                                                    .font(.system(size: 10, weight: .semibold))
                                                    .foregroundColor(.black)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(Color.white.opacity(0.85))
                                                    .clipShape(Capsule())
                                            }
                                        }
                                        
                                        Text(app.urlScheme)
                                            .font(.system(size: 12, design: .monospaced))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        openOrIntervene(appName: app.name, url: app.url)
                                    }) {
                                        Text("Öffnen")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 6)
                                            .background(Color.white)
                                            .clipShape(Capsule())
                                    }
                                }
                                .padding(12)
                                .background(Color(white: 0.08))
                                .cornerRadius(12)
                            }
                        }
                    }
                    
                    // MARK: - Anleitung zur Funktionsweise
                    VStack(alignment: .leading, spacing: 12) {
                        Text("WIE DIE ABFANG-ROUTINE FUNKTIONIERT")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            stepRow(number: "1", text: "Tippst du im Widget auf eine Social-Media-App, leitet das Widget über 'minimalist://intervene' zuerst in unsere App weiter.")
                            stepRow(number: "2", text: "Der vollflächige schwarze Zwischenscreen erscheint mit 10-Sekunden Countdown-Kreis.")
                            stepRow(number: "3", text: "'Abbrechen' schließt den Screen sofort, ohne die App zu öffnen.")
                            stepRow(number: "4", text: "'Weiter' wird erst nach Ablauf der 10 Sekunden aktiv und öffnet dann die Ziel-App.")
                        }
                        .padding(16)
                        .background(Color(white: 0.08))
                        .cornerRadius(14)
                    }
                }
                .padding(20)
            }
            .background(Color(white: 0.03).ignoresSafeArea())
            .navigationTitle("Minimalist Widget")
            // Eingehende Deep Links aus Widget verarbeiten
            .onOpenURL { incomingURL in
                interventionManager.handleIncomingURL(incomingURL)
            }
            // Vollflächiger Achtsamkeits-Zwischenscreen
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
    
    // MARK: - Öffnen oder Abfangen
    private func openOrIntervene(appName: String, url: URL) {
        if TimeWastingApps.isTimeWasting(url: url) {
            interventionManager.triggerIntervention(appName: appName, targetURL: url)
        } else {
            openURL(url) { success in
                if !success {
                    activeAlertMessage = "Konnte '\(url.absoluteString)' nicht öffnen. Bitte prüfe, ob die App installiert ist."
                }
            }
        }
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
                    Text("Pause testen")
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
    
    private func stepRow(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 22, height: 22)
                .background(Color.white)
                .clipShape(Circle())
            
            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.85))
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
