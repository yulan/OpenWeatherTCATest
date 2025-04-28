////
////  StoryReducerTests.swift
////  OpenWeatherTCATest
////
////  Created by Lan YU on 28/04/2025.
////
//
import XCTest
import ComposableArchitecture
@testable import OpenWeatherTCATest

final class StoriesReducerTests: XCTestCase {

    let initialState = StoriesReducer.State(city: "Paris")
    
    func testFetchSuccess() async throws {
        let mockRepository = MockStoryService.successMock
        let reducer = StoriesReducer()
    
        let store = await TestStore(
            initialState: initialState,
            reducer: {
                reducer
            }) {
                $0.storyRepository = mockRepository
            }
        
        await store.send(.fetch) {
            $0.isLoading = true
        }
        
        let fetchRandomPhotoNb = reducer.fetchRandomPhotoNb
        let urls = (1...fetchRandomPhotoNb).compactMap { URL(string: "https://example.com/Paris_photo\($0).jpg")
        }
        
        await store.receive(.fetchResponse(.success(urls))) {
            $0.isLoading = false
            $0.stories = [
                Story(imageURL: URL(string: "https://example.com/Paris_photo1.jpg")!),
                Story(imageURL: URL(string: "https://example.com/Paris_photo2.jpg")!),
                Story(imageURL: URL(string: "https://example.com/Paris_photo3.jpg")!),
                Story(imageURL: URL(string: "https://example.com/Paris_photo4.jpg")!),
                Story(imageURL: URL(string: "https://example.com/Paris_photo5.jpg")!)
            ]
            $0.currentIndex = 0
            $0.progress = 0.0
        }
    }

    func testFetchFailure() async throws {
        let mockRepository = MockStoryService.failureMock
    
        let store = await TestStore(
            initialState: initialState,
            reducer: {
                StoriesReducer()
            }) {
                $0.storyRepository = mockRepository
            }

        await store.send(.fetch) {
            $0.isLoading = true
        }

        await store.receive(.fetchResponse(.failure(URLError(.cannotLoadFromNetwork)))) {
            $0.isLoading = false
            $0.stories = []
            $0.errorMessage = URLError(.cannotLoadFromNetwork).localizedDescription
        }
    }

    func testNextAndPreviousStory() async {
        let initialStories = [
            Story(imageURL: URL(string: "https://example.com/1.jpg")!),
            Story(imageURL: URL(string: "https://example.com/2.jpg")!),
            Story(imageURL: URL(string: "https://example.com/2.jpg")!)
        ]

        let store = await TestStore(
            initialState: StoriesReducer.State(
                city: "Paris",
                stories: initialStories
            )
        ) {
            StoriesReducer()
        }

        await store.send(.next) {
            $0.currentIndex = 1
            $0.progress = 0.0
        }

        await store.send(.next) {
            $0.currentIndex = 2
            $0.progress = 0.0
        }
        
        await store.send(.previous) {
            $0.currentIndex = 1
            $0.progress = 0.0
        }
        
        await store.send(.next) {
            $0.currentIndex = 2
            $0.progress = 0.0
        }

        await store.send(.next) {
            $0.currentIndex = 0 // new tour
            $0.progress = 0.0
        }
    }

    func testUpdateProgress() async {
        let store = await TestStore(initialState: StoriesReducer.State(city: "Paris")) {
            StoriesReducer()
        }

        await store.send(.updateProgress(0.5)) {
            $0.progress = 0.5
        }
    }

    func testDismissError() async {
        let store = await TestStore(initialState: StoriesReducer.State(city: "Paris", errorMessage: "Error")) {
            StoriesReducer()
        }

        await store.send(.dismissError) {
            $0.errorMessage = nil
        }
    }
}
