//
//  WeatherService.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 24/04/2025.
//

import Foundation
import ComposableArchitecture

struct WeatherService: WeatherRepositoryProtocol {
    func fetchWeather(
        lat: Double,
        lon: Double
    ) async throws -> WeatherResponseDTO {
        let apiKey = APIKeys.openWeather
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let weatherUrl = URL(string: urlString) else {
            throw WeatherAPIClientError.invalidURL
        }
        
        // Create a URLRequest
        let userRequest = URLRequest(
            url: weatherUrl
        )
        
        // Use DefaultDataTransferService to fetch and decode the data
        let dataTransferService = DefaultDataTransferService(
            networkService: URLSessionHTTPClient(
                session: .shared
            )
        )
        
        let result: Result<WeatherResponseDTO,Error> = await dataTransferService.request(
            from: userRequest
        )
        
        switch result {
        case .success(let weather):
            /// (Optional) Clearing cache and cookies from previous URLSession
            await URLSession.shared
                .reset()
            return weather
        case .failure(let error):
            throw mapError(
                error
            )
        }
    }
    
    private func mapError(_ error: Error) -> WeatherAPIClientError {
        if let _ = error as? URLError {
            return .requestFailed
        } else if let _ = error as? DecodingError {
            return .decodingFailed
        } else {
            return .unknown
        }
    }
}

// MARK: - WeatherAPIClientError Enum
enum WeatherAPIClientError: Error, Equatable {
    case invalidURL
    case requestFailed
    case decodingFailed
    case invalidResponse
    case apiError(message: String)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .requestFailed:
            return "The request to the server failed."
        case .decodingFailed:
            return "Failed to decode the weather data from the server."
        case .invalidResponse:
            return "The server response was invalid."
        case let .apiError(message):
            return "API Error: \(message)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

// MARK: - DependencyValues Integration
extension DependencyValues {
    var weatherRepository: WeatherRepositoryProtocol {
        get {
            self[WeatherRepositoryKey.self]
        }
        set {
            self[WeatherRepositoryKey.self] = newValue
        }
    }
}

private enum WeatherRepositoryKey: DependencyKey {
    static let liveValue: WeatherRepositoryProtocol = WeatherService()
    static let testValue: WeatherRepositoryProtocol = MockWeatherRepository()
}

// MARK: - Mock Repository for Testing
struct MockWeatherRepository: WeatherRepositoryProtocol {
    func fetchWeather(
        lat: Double,
        lon: Double
    ) async throws -> WeatherResponseDTO {
        // Return a mocked response for testing
        return WeatherResponseDTO(
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
    }
}
