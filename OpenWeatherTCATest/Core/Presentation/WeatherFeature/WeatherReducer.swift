//
//  WeatherReducer.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 21/04/2025.
//

import SwiftUI
import ComposableArchitecture
import CoreLocation

enum WeatherError: Error {
    case api(Error)
    case networkFailure
    case permissionDenied
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .api(let error):
            return "API Error: \(error.localizedDescription)"
        case .networkFailure:
            return "Network connection failed. Please check your internet connection."
        case .permissionDenied:
            return "Location permissions are required to fetch the weather."
        case .unknown(let info):
            return "An unknown error occurred: \(info)"
        }
    }
}

@Reducer
struct WeatherReducer {
    @ObservableState
    struct State {
        var weather: Weather? = nil
        var lastLocation: CLLocation?
        var isFetchingWeather: Bool = false
        var errorType: WeatherError?
        var showStories = false
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    @CasePathable
    enum Action {
        case locationPermissionDenied(String)
        case retryRequestAuthorization
        case fetchWeather(CLLocation)
        case retryLastFetchWeather
        case weatherResponse(Result<Weather, WeatherError>)
        case navigateToStories(Bool)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert {
            case openSettingsTapped
            case cancelTapped
        }
    }
    
    @Dependency(\.weatherRepository) var weatherRepository
    @Dependency(\.openURL) var openURL
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .locationPermissionDenied(errorMessage):
                state.alert = AlertState {
                    TextState(errorMessage)
                } actions: {
                    ButtonState(role: .cancel, action: .cancelTapped) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .openSettingsTapped) {
                        TextState("Open Settings")
                    }
                } message: {
                    TextState("Please enable location permissions in Settings to use weather features.")
                }
                state.errorType = WeatherError.permissionDenied
                return .none
                
            case .retryRequestAuthorization:
                return .none
                
            case .alert(.presented(.openSettingsTapped)):
                return .run { _ in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        await openURL(url)
                    }
                }
                
            case .alert(.presented(.cancelTapped)):
                state.alert = nil
                return .none
                
            case .alert:
                return .none
                
            case .fetchWeather(let location):
                state.isFetchingWeather = true
                state.errorType = nil
                state.lastLocation = location
                return .run { send in
                    do {
                        let lat = location.coordinate.latitude
                        let lon = location.coordinate.longitude
                        let weatherDTO = try await weatherRepository.fetchWeather(for: lat, and: lon)
                        let weather = weatherDTO.toDomain()
                        await send(.weatherResponse(.success(weather)))
                    } catch let error as WeatherError {
                        await send(.weatherResponse(.failure(error)))
                    }
                }
                
            case .retryLastFetchWeather:
                guard let lastlocation = state.lastLocation else {
                    state.errorType = WeatherError.unknown("The lastLocation should not be nil !!")
                    return .none
                }
                return .run { send in
                    do {
                        let lat = lastlocation.coordinate.latitude
                        let lon = lastlocation.coordinate.longitude
                        let weatherDTO = try await weatherRepository.fetchWeather(for: lat, and: lon)
                        let weather = weatherDTO.toDomain()
                        await send(.weatherResponse(.success(weather)))
                    } catch let error as WeatherError {
                        await send(.weatherResponse(.failure(error)))
                    }
                }
                
            case let .weatherResponse(.success(weather)):
                state.weather = weather
                state.errorType = nil
                state.isFetchingWeather = false
                return .none
                
            case let .weatherResponse(.failure(error)):
                state.isFetchingWeather = false
                state.errorType = error
                return .none
                
            case let .navigateToStories(show):
                state.showStories = show
                return .none
                
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - State Equatable
extension WeatherReducer.State: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.weather == rhs.weather &&
        lhs.isFetchingWeather == rhs.isFetchingWeather &&
        lhs.errorType == rhs.errorType &&
        lhs.showStories == rhs.showStories &&
        lhs.alert == rhs.alert
    }
}

// MARK: - Action Equatable
extension WeatherReducer.Action: Equatable {
    static func == (lhs: WeatherReducer.Action, rhs: WeatherReducer.Action) -> Bool {
        switch (lhs, rhs) {
        case let (.locationPermissionDenied(a), .locationPermissionDenied(b)):
            return a == b
            
        case let (.fetchWeather(a), .fetchWeather(b)):
            return a.coordinate.latitude == b.coordinate.latitude &&
            a.coordinate.longitude == b.coordinate.longitude
            
        case let (.weatherResponse(.success(a)), .weatherResponse(.success(b))):
            return a == b
            
        case let (.weatherResponse(.failure(a)), .weatherResponse(.failure(b))):
            return a.localizedDescription == b.localizedDescription
            
        case let (.navigateToStories(a), .navigateToStories(b)):
            return a == b
            
        case (.alert, .alert):
            return true
            
        default:
            return false
        }
    }
}

// MARK: - WeatherError Equatable
extension WeatherError: Equatable {
    static func == (lhs: WeatherError, rhs: WeatherError) -> Bool {
        switch (lhs, rhs) {
        case (.networkFailure, .networkFailure),
            (.permissionDenied, .permissionDenied):
            return true
        case (let .api(lhsError), let .api(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (let .unknown(lhsInfo), let .unknown(rhsInfo)):
            return lhsInfo == rhsInfo
        default:
            return false
        }
    }
}
