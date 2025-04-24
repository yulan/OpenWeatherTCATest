//
//  WeatherResponseDTO.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 22/04/2025.
//

import Foundation

struct WeatherResponseDTO: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case main
        case wind
        case clouds
        case sys
        case name
        case visibility
        case timestamp = "dt"
    }
    
    let coord: CoordDTO?
    let weather: [WeatherConditionDTO]?
    let main: MainDTO?
    let wind: WindDTO?
    let clouds: CloudsDTO?
    let sys: SysDTO?
    let name: String?
    let visibility: Int?
    let timestamp: Int32?
}

struct CoordDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
    
    let lat: Double?
    let lon: Double?
}

struct WeatherConditionDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
    
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct MainDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
    
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
}

struct WindDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case speed
        case deg
        case gust
    }
    
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct CloudsDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case all
    }
    
    let all: Int? // Cloudiness percentage
}

struct SysDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case country
        case sunrise
        case sunset
    }
    
    let country: String?
    let sunrise: Int32?
    let sunset: Int32?
}

extension WeatherResponseDTO {
    func toDomain() -> Weather {
        let weatherConditions = weather?.compactMap {
            Weather.WeatherCondition.init(
                id: $0.id,
                main: $0.main,
                description: $0.description,
                icon: $0.icon
            )
        }
        
        let sunriseDate = Date.fromUnixTimestamp(sys?.sunrise)
        let sunsetDate = Date.fromUnixTimestamp(sys?.sunset)
        let timestampDate = Date.fromUnixTimestamp(timestamp)
        
        return
            .init(
                lat: coord?.lat,
                lon: coord?.lon,
                weatherConditions: weatherConditions,
                temp: main?.temp,
                feelsLike: main?.feelsLike,
                tempMin: main?.tempMin,
                tempMax: main?.tempMax,
                pressure: main?.pressure,
                humidity: main?.humidity,
                windSpeed: wind?.speed,
                windDeg: wind?.deg,
                windGust: wind?.gust,
                cloudsAll: clouds?.all,
                sunCountry: sys?.country,
                sunSunrise: sunriseDate,
                sunSet: sunsetDate,
                name: name,
                visibility: visibility,
                timestamp: timestampDate
        )
    }
}
