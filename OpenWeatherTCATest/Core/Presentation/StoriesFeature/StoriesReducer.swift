//
//  StoriesReducer.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 17/04/2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct StoriesReducer {

    struct State: Equatable {
        var city: String
        var stories: [Story] = []
        var currentIndex: Int = 0
        var progress: Double = 0.0
        var isLoading = false
        var errorMessage: String?
    }

    enum Action {
        case fetch
        case fetchResponse(Result<[URL], Error>)
        case dismissError
        case next
        case previous
        case updateProgress(Double)
    }
    
    @Dependency(\.storyRepository) var storyRepository

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            case .fetch:
                state.isLoading = true
                return .run { [city = state.city] send in
                    let result = await Result {
                        try await storyRepository.fetchRandomPhotoURLs(for: city, with: 5)
                    }
                    await send(.fetchResponse(result))
                }

            case let .fetchResponse(.success(urls)):
                state.isLoading = false
                state.stories = urls.map { Story(imageURL: $0) }
                state.currentIndex = 0
                state.progress = 0.0
                return .none

            case let .fetchResponse(.failure(error)):
                state.isLoading = false
                state.stories = []
                state.errorMessage = error.localizedDescription
                return .none

            case let .updateProgress(value):
                state.progress = value
                return .none

            case .next:
                if state.currentIndex < state.stories.count - 1 {
                    state.currentIndex += 1
                } else {
                    state.currentIndex = 0
                }
                state.progress = 0.0
                return .none

            case .previous:
                if state.currentIndex > 0 {
                    state.currentIndex -= 1
                } else {
                    state.currentIndex = 0
                }
                state.progress = 0.0
                return .none
                
            case .dismissError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}
