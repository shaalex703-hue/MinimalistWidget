//
//  MindfulPauseView.swift
//  MinimalistApp
//

import SwiftUI
import Combine

/// Vollflächiger Zwischenscreen zur achtsamen Reflexion vor dem Öffnen zeitfressender Apps
public struct MindfulPauseView: View {
    public let targetAppName: String
    public let targetURL: URL
    public let onDismiss: () -> Void
    
    @State private var remainingSeconds: Int = 10
    @State private var timerSubscription: AnyCancellable?
    @Environment(\.openURL) private var openURL
    
    private let totalSeconds: Double = 10.0
    
    public init(targetAppName: String, targetURL: URL, onDismiss: @escaping () -> Void) {
        self.targetAppName = targetAppName
        self.targetURL = targetURL
        self.onDismiss = onDismiss
    }
    
    private var progress: Double {
        Double(10 - remainingSeconds) / totalSeconds
    }
    
    private var isCompleted: Bool {
        remainingSeconds <= 0
    }
    
    public var body: some View {
        ZStack {
            // Rein schwarzer Hintergrund
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Dezente Kennzeichnung der Ziel-App
                if !targetAppName.isEmpty {
                    Text(targetAppName.uppercased())
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.4))
                        .tracking(3)
                        .padding(.bottom, 36)
                }
                
                // MARK: - Countdown-Kreis & Textzähler (10 Sekunden)
                ZStack {
                    // Hintergrund-Ring
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 2.5)
                        .frame(width: 140, height: 140)
                    
                    // Animierter Fortschritts-Ring
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color.white,
                            style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                        )
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.95), value: progress)
                    
                    // Zentrierter Sekundenzähler
                    VStack(spacing: 2) {
                        Text("\(remainingSeconds)")
                            .font(.system(size: 52, weight: .ultraLight, design: .default))
                            .foregroundColor(.white)
                            .monospacedDigit()
                            .contentTransition(.numericText())
                        
                        Text(remainingSeconds == 1 ? "SEKUNDE" : "SEKUNDEN")
                            .font(.system(size: 9, weight: .medium, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.5))
                            .tracking(1.5)
                    }
                }
                .padding(.bottom, 44)
                
                // MARK: - Achtsamkeits-Aufforderung
                Text("Nimm dir einen Moment Zeit. Musst du diese App jetzt wirklich öffnen?")
                    .font(.system(size: 21, weight: .light, design: .default))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, 36)
                    .frame(maxWidth: 420)
                
                Spacer()
                
                // MARK: - Schlichte Text-Buttons: "Abbrechen" & "Weiter"
                VStack(spacing: 16) {
                    // Button "Weiter" (erst nach Ablauf des Countdowns aktivierbar)
                    Button(action: {
                        guard isCompleted else { return }
                        openTargetApp()
                    }) {
                        Text("Weiter")
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .foregroundColor(isCompleted ? Color.black : Color.white.opacity(0.25))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(isCompleted ? Color.white : Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .disabled(!isCompleted)
                    .animation(.easeInOut(duration: 0.3), value: isCompleted)
                    
                    // Button "Abbrechen" (schließt den Zwischenscreen)
                    Button(action: {
                        stopTimer()
                        onDismiss()
                    }) {
                        Text("Abbrechen")
                            .font(.system(size: 16, weight: .light, design: .default))
                            .foregroundColor(Color.white.opacity(0.7))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 36)
            }
        }
        .onAppear {
            startCountdown()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // MARK: - Timer-Steuerung
    private func startCountdown() {
        remainingSeconds = 10
        stopTimer()
        
        timerSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if remainingSeconds > 1 {
                    remainingSeconds -= 1
                } else if remainingSeconds == 1 {
                    remainingSeconds = 0
                    stopTimer()
                    triggerHaptic()
                }
            }
    }
    
    private func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }
    
    private func triggerHaptic() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #endif
    }
    
    private func openTargetApp() {
        stopTimer()
        onDismiss()
        openURL(targetURL)
    }
}

#Preview {
    MindfulPauseView(
        targetAppName: "Instagram",
        targetURL: URL(string: "instagram://")!,
        onDismiss: {}
    )
}
