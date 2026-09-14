//
//  TimeWastingApps.swift
//  MinimalistWidget
//

import Foundation

/// Erkennt und verwaltet zeitfressende Apps (Social Media, Endlos-Feeds)
public struct TimeWastingApps: Sendable {
    
    /// Bekannte URL-Schemes und Hostnamen zeitfressender Apps
    public static let knownSchemes: Set<String> = [
        "instagram",
        "tiktok",
        "snssdk1233",
        "snssdk1180",
        "youtube",
        "vnd.youtube",
        "twitter",
        "x",
        "fb",
        "facebook",
        "reddit",
        "snapchat",
        "threads",
        "barcelona",
        "pinterest",
        "linkedin",
        "twitch",
        "nflx"
    ]
    
    public static let knownHosts: Set<String> = [
        "instagram.com",
        "www.instagram.com",
        "tiktok.com",
        "www.tiktok.com",
        "youtube.com",
        "www.youtube.com",
        "m.youtube.com",
        "twitter.com",
        "x.com",
        "facebook.com",
        "reddit.com",
        "threads.net"
    ]
    
    /// Prüft, ob ein gegebener URL oder ein Scheme zu einer zeitfressenden App gehört
    public static func isTimeWasting(url: URL) -> Bool {
        if let scheme = url.scheme?.lowercased(), knownSchemes.contains(scheme) {
            return true
        }
        if let host = url.host?.lowercased(), knownHosts.contains(host) {
            return true
        }
        return false
    }
    
    /// Prüft, ob ein Scheme-String zeitfressend ist
    public static func isTimeWasting(schemeString: String) -> Bool {
        let cleaned = schemeString.replacingOccurrences(of: "://", with: "").lowercased()
        return knownSchemes.contains(cleaned)
    }
    
    /// Erzeugt die passende Widget-Ziel-URL:
    /// Zeitfressende Apps werden über 'minimalist://intervene?...' an unsere App geleitet.
    /// Alle anderen Apps öffnen direkt.
    public static func destinationURL(for appName: String, rawScheme: String) -> URL {
        guard let targetURL = URL(string: rawScheme) else {
            return URL(string: "about:blank")!
        }
        
        if isTimeWasting(url: targetURL) {
            var components = URLComponents()
            components.scheme = "minimalist"
            components.host = "intervene"
            components.queryItems = [
                URLQueryItem(name: "url", value: rawScheme),
                URLQueryItem(name: "name", value: appName)
            ]
            return components.url ?? targetURL
        }
        
        return targetURL
    }
}
