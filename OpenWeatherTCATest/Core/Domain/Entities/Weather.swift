//
//  Weather.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 24/04/2025.
//

import Foundation

public struct Weather: Equatable {
    let lat: Double?
    let lon: Double?

    let weatherConditions: [WeatherCondition]?
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    let windSpeed: Double?
    let windDeg: Int?
    let windGust: Double?
    let cloudsAll: Int?
    
    let sunCountry: String?
    let sunSunrise: Date?
    let sunSet: Date?
    
    let name: String?
    let visibility: Int?
    let timestamp: Date?
    
    public struct WeatherCondition: Equatable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
        
        public static func == (
            lhs: WeatherCondition,
            rhs: WeatherCondition
        ) -> Bool {
            return lhs.id == rhs.id &&
                lhs.main == rhs.main &&
                lhs.description == rhs.description &&
                lhs.icon == rhs.icon
        }
    }
    
    public static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.lat == rhs.lat &&
            lhs.lon == rhs.lon &&
            lhs.weatherConditions == rhs.weatherConditions &&
            lhs.temp == rhs.temp &&
            lhs.feelsLike == rhs.feelsLike &&
            lhs.tempMin == rhs.tempMin &&
            lhs.tempMax == rhs.tempMax &&
            lhs.pressure == rhs.pressure &&
            lhs.humidity == rhs.humidity &&
            lhs.windSpeed == rhs.windSpeed &&
            lhs.windDeg == rhs.windDeg &&
            lhs.windGust == rhs.windGust &&
            lhs.cloudsAll == rhs.cloudsAll &&
            lhs.sunCountry == rhs.sunCountry &&
            lhs.sunSunrise == rhs.sunSunrise &&
            lhs.sunSet == rhs.sunSet &&
            lhs.name == rhs.name &&
            lhs.visibility == rhs.visibility &&
            lhs.timestamp == rhs.timestamp
    }
}
