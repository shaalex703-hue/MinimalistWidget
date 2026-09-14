//
//  InterventionManager.swift
//  MinimalistApp
//

import SwiftUI
import Combine

/// Verwaltet das Abfangen von zeitfressenden Apps aus dem Widget und der Haupt-App
@MainActor
public final class InterventionManager: ObservableObject {
    public static let shared = InterventionManager()
    
    @Published public var isInterventionActive: Bool = false
    @Published public var targetAppName: String = ""
    @Published public var targetURL: URL = URL(string: "about:blank")!
    
    public init() {}
    
    /// Startet manuell die 10-Sekunden-Achtsamkeitspause für eine App
    public func triggerIntervention(appName: String, targetURL: URL) {
        self.targetAppName = appName
        self.targetURL = targetURL
        self.isInterventionActive = true
    }
    
    /// Verarbeitet eingehende Deep Links (z. B. aus dem Widget)
    /// Format: minimalist://intervene?url=instagram://&name=Instagram
    public func handleIncomingURL(_ url: URL) {
        guard url.scheme?.lowercased() == "minimalist" else { return }
        
        // Entweder Host "intervene" oder Pfad "/intervene"
        let isIntervene = (url.host?.lowercased() == "intervene") || (url.path.lowercased().contains("intervene"))
        guard isIntervene else { return }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return }
        
        let targetRawURL = queryItems.first(where: { $0.name == "url" })?.value ?? ""
        let appName = queryItems.first(where: { $0.name == "name" })?.value ?? "Social Media"
        
        if let target = URL(string: targetRawURL) {
            triggerIntervention(appName: appName, targetURL: target)
        }
    }
    
    /// Schließt den Zwischenscreen
    public func dismiss() {
        self.isInterventionActive = false
    }
}
