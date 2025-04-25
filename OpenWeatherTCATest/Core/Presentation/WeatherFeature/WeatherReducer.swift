import SwiftUI
import ComposableArchitecture
import CoreLocation

enum WeatherFetchError: Error {
    case location(Error)
    case api(Error)
    case unknown(Error)
}

@Reducer
struct WeatherReducer {
    struct State {
        var weather: Weather? = nil
        var isFetchingWeather: Bool = false
        var errorMessage: String?
        var showStories = false
    }

    @CasePathable
    enum Action {
        case fetchWeather(Double, Double)
        case weatherResponse(Result<Weather, WeatherFetchError>)
        case didReceiveError(String)
        case navigateToStories(Bool)
    }

    @Dependency(\.weatherRepository) var weatherRepository
    @Dependency(\.openURL) var openURL

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .fetchWeather(lat, lon):
                state.isFetchingWeather = true
                state.errorMessage = nil
                return .run { send in
                    do {
                        let weatherDTO = try await weatherRepository.fetchWeather(lat: lat, lon: lon)
                        let weather = weatherDTO.toDomain()
                        await send(.weatherResponse(.success(weather)))
                    } catch let error as WeatherFetchError {
                        await send(.weatherResponse(.failure(error)))
                    }
                }

            case .weatherResponse(.success(let weather)):
                state.weather = weather
                state.isFetchingWeather = false
                return .none

            case .weatherResponse(.failure(let error)):
                state.isFetchingWeather = false
                state.errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
                return .none
                
            case .didReceiveError(let message):
                state.errorMessage = message
                return .none
                
            case .navigateToStories(let show):
                state.showStories = show
                return .none
            }
        }
    }
}
