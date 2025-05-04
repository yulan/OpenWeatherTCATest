//
//  WeatherService.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 24/04/2025.
//

import Foundation
import ComposableArchitecture

struct WeatherService: WeatherRepositoryProtocol {
    func fetchWeather(for lat: Double, and lon: Double) async throws -> WeatherResponseDTO {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(APIKeys.openWeather)&units=metric"
        
        guard let weatherUrl = URL(string: urlString) else {
            throw WeatherAPIClientError.invalidURL
        }
        
        let userRequest = URLRequest(url: weatherUrl)
        let networkService = URLSessionHTTPClient(session: .shared)
        let dataTransferService = DefaultDataTransferService(networkService: networkService)
        let result: Result<WeatherResponseDTO,Error> = await dataTransferService.request(from: userRequest)
        
        switch result {
        case let .success(weather):
            /// (Optional) Clearing cache and cookies from previous URLSession
            await URLSession.shared.reset()
            return weather
        case let .failure(error):
            throw mapError(error)
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
        get { self[WeatherRepositoryKey.self] }
        set { self[WeatherRepositoryKey.self] = newValue }
    }
}

private enum WeatherRepositoryKey: DependencyKey {
    static let liveValue: WeatherRepositoryProtocol = WeatherService()
}
