//
//  MockWeatherService.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 25/04/2025.
//

import Foundation
import ComposableArchitecture

struct MockWeatherService: WeatherRepositoryProtocol {
    
    let result: Result<WeatherResponseDTO, WeatherError>
    
    static let weatherDTO = WeatherResponseDTO(
        coord: CoordDTO(
            lat: 48.893732,
            lon: 2.406402
        ),
        weather: [
            WeatherConditionDTO(
                id: 800,
                main: "Clear",
                description: "clear sky",
                icon: "01d"
            )
        ],
        main: MainDTO(
            temp: 18.5,
            feelsLike: 18.0,
            tempMin: 16.5,
            tempMax: 20.0,
            pressure: 1013,
            humidity: 60
        ),
        wind: WindDTO(
            speed: 3.1,
            deg: 180,
            gust: nil
        ),
        clouds: CloudsDTO(
            all: 0
        ),
        sys: SysDTO(
            country: "FR",
            sunrise: 1650264000,
            sunset: 1650314400
        ),
        name: "Paris",
        visibility: 10000,
        timestamp: 1650280800
    )
    
    func fetchWeather(
        for lat: Double,
        and lon: Double
    ) async throws -> WeatherResponseDTO {
        switch result {
        case .success(let weather):
            return weather
        case .failure(let error):
            throw error
        }
    }
}
