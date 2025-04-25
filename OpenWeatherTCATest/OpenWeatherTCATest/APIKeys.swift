//
//  APIKeys.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 24/04/2025.
//

import Foundation

enum APIKeys {
    static var openWeather: String {
        guard let key = Bundle.main.infoDictionary?["OpenWeatherAPIKey"] as? String, !key.isEmpty else {
            assertionFailure("❌ OpenWeatherAPIKey not found or empty in Info.plist")
            return ""
        }
        return key
    }
    
    static var Unsplash: String {
        guard let key = Bundle.main.infoDictionary?["UnsplashAPIKey"] as? String, !key.isEmpty else {
            assertionFailure("❌ OpenWeatherAPIKey not found or empty in Info.plist")
            return ""
        }
        return key
    }
}
