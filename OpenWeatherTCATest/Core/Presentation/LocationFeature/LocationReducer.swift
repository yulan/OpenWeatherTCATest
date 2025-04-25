//
//  LocationReducer.swift
//  WeatherTCAApp
//
//  Created by Lan YU on 24/04/2025.
//

import SwiftUI
import ComposableArchitecture
import CoreLocation

@Reducer
struct LocationReducer {
    struct State {
        var authorizationStatus: CLAuthorizationStatus = .notDetermined
        var currentLocation: CLLocation?
        var isFetchingLocation: Bool = false
        var errorMessage: String?
    }
    
    @CasePathable
    enum Action {
        case requestAuthorization
        case locationPermissionDenied(String)
        case authorizationResponse(CLAuthorizationStatus)
        case requestCurrentLocation
        case currentLocationResponse(Result<CLLocation, Error>)
    }
    
    @Dependency(\.locationRepository) var locationRepository
    @Dependency(\.openURL) var openURL
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestAuthorization:
                locationRepository.requestAuthorization()
                
                // Immediately send the current authorization status
                // (in case the permission was already granted and no new event is emitted from the stream)
                let initialStatus = locationRepository.getAuthorizationStatus()
                
                return .merge(
                    .send(.authorizationResponse(initialStatus)),
                    .run { send in
                        for await status in locationRepository.getAuthorizationStatusStream() {
                            await send(.authorizationResponse(status))
                        }
                    }
                )
            case .authorizationResponse(let status):
                state.authorizationStatus = status
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    return .send(.requestCurrentLocation)
                } else if status == .denied || status == .restricted {
                    // 触发父级 reducer 捕捉此事件并弹出 alert
                    //return .send(.delegate(.locationPermissionDenied))
                    return .send(.locationPermissionDenied("utilisateur donner pas droit"))
                }
                return .none
                
//            case .alert(.presented(.openSettingsTapped)):
//                return .run { _ in
//                    if let url = URL(string: UIApplication.openSettingsURLString) {
//                        await openURL(url)
//                    }
//                }
//                
//            case .alert(.presented(.cancelTapped)):
//                return .none
//                
//            case .alert:
//                return .none
                
            case .requestCurrentLocation:
                guard state.authorizationStatus == .authorizedWhenInUse || state.authorizationStatus == .authorizedAlways else {
                    state.errorMessage = "Location access not authorized."
                    return .none
                }
                state.isFetchingLocation = true
                return .run { send in
                    do {
                        let locationRepository = try await locationRepository.getCurrentLocation()
                        await send(.currentLocationResponse(.success(locationRepository)))
                    } catch {
                        await send(.currentLocationResponse(.failure(error)))
                    }
                }
                
            case .currentLocationResponse(.success(let location)):
                state.isFetchingLocation = false
                state.currentLocation = location
                return .none
                
            case .currentLocationResponse(.failure(let error)):
                state.isFetchingLocation = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case let .locationPermissionDenied(errorMessage):
                state.errorMessage = errorMessage
                return .none
            }
        }
    }
}
