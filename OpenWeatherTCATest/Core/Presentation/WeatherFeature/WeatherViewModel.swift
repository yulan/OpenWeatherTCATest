//
//  WeatherViewModel.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 21/04/2025.
//

import Foundation

struct WeatherViewModel {
    private let weather: Weather

    init(weather: Weather) {
        self.weather = weather
    }

    // MARK: - Latitude and Longitude
    var latitude: String {
        guard let lat = weather.lat else { return "Unknown Latitude" }
        return "\(lat)"
    }

    var longitude: String {
        guard let lon = weather.lon else { return "Unknown Longitude" }
        return "\(lon)"
    }

    // MARK: - Weather Conditions
    var conditionDescription: String {
        guard let conditions = weather.weatherConditions, !conditions.isEmpty else {
            return "No Weather Conditions Available"
        }
        return conditions.map { $0.description ?? "No Description" }.joined(separator: ", ")
    }

    var conditionIcons: [String] {
        guard let conditions = weather.weatherConditions else { return [] }
        return conditions.compactMap { $0.icon }
    }

    // MARK: - Temperature
    var temperature: String {
        guard let temp = weather.temp else { return "Unknown Temperature" }
        return "\(temp)°C"
    }

    var feelsLikeTemperature: String {
        guard let feelsLike = weather.feelsLike else { return "Unknown Feels Like Temperature" }
        return "\(feelsLike)°C"
    }

    var minTemperature: String {
        guard let tempMin = weather.tempMin else { return "Unknown Min Temperature" }
        return "\(tempMin)°C"
    }

    var maxTemperature: String {
        guard let tempMax = weather.tempMax else { return "Unknown Max Temperature" }
        return "\(tempMax)°C"
    }

    // MARK: - Pressure and Humidity
    var pressure: String {
        guard let pressure = weather.pressure else { return "Unknown Pressure" }
        return "\(pressure) hPa"
    }

    var humidity: String {
        guard let humidity = weather.humidity else { return "Unknown Humidity" }
        return "\(humidity)%"
    }

    // MARK: - Wind
    var windSpeed: String {
        guard let speed = weather.windSpeed else { return "Unknown Wind Speed" }
        return "\(speed) m/s"
    }

    var windDirection: String {
        guard let deg = weather.windDeg else { return "Unknown Wind Direction" }
        let directions = ["N","NE","E","SE","S","SW","W","NW"]
        let index = Int((Double(deg) + 22.5) / 45.0) % 8
        return directions[index]
    }

    var windGust: String {
        guard let gust = weather.windGust else { return "Unknown Wind Gust" }
        return "\(gust) m/s"
    }

    // MARK: - Clouds
    var cloudiness: String {
        guard let clouds = weather.cloudsAll else { return "Unknown Cloudiness" }
        return "\(clouds)%"
    }

    // MARK: - Sun Information
    var country: String {
        guard let country = weather.sunCountry else { return "Unknown Country" }
        return country
    }

    var sunriseTime: String {
        guard let sunrise = weather.sunSunrise else { return "Unknown Sunrise Time" }
        return sunrise.to24HourTimeString()
    }

    var sunsetTime: String {
        guard let sunset = weather.sunSet else { return "Unknown Sunset Time" }
        return sunset.to24HourTimeString()
    }

    // MARK: - Location Name and Visibility
    var locationName: String {
        return weather.name ?? "Unknown Location"
    }

    var visibility: String {
        guard let visibility = weather.visibility else { return "Unknown Visibility" }
        return "\(visibility) meters"
    }

    // MARK: - Timestamp
    var lastTimeUpdated: String {
        guard let timestamp = weather.timestamp else { return "Unknown Update Time" }
        return timestamp.to24HourTimeString()
    }
    
    var lastDateUpdated: String {
        guard let timestamp = weather.timestamp else { return "Unknown Update Time" }
        return timestamp.toDateString()
    }
}
