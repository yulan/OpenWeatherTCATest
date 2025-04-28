////
////  StoryReducerTests.swift
////  OpenWeatherTCATest
////
////  Created by Lan YU on 28/04/2025.
////
//
//import XCTest
//import ComposableArchitecture
//@testable import OpenWeatherTCATest
//
//@MainActor
//final class StoryReducerTests: XCTestCase {
//    func testFetchStories_Success() async {
//        let store = TestStore(
//            initialState: StoryReducer.State(),
//            reducer: StoryReducer()
//        )
//        
//        store.dependencies.storyRepository.fetchRandomPhotoURLs = { _, _ in
//            [
//                URL(string: "https://example.com/photo1.jpg")!,
//                URL(string: "https://example.com/photo2.jpg")!
//            ]
//        }
//        
//        await store.send(.fetchPhotos(city: "Cupertino", count: 2)) {
//            $0.isLoading = true
//        }
//        
//        await store.receive(.photosResponse(.success([
//            URL(string: "https://example.com/photo1.jpg")!,
//            URL(string: "https://example.com/photo2.jpg")!
//        ]))) {
//            $0.isLoading = false
//            $0.photoURLs = [
//                URL(string: "https://example.com/photo1.jpg")!,
//                URL(string: "https://example.com/photo2.jpg")!
//            ]
//        }
//    }
//    
//    func testFetchStories_Failure() async {
//        let store = TestStore(
//            initialState: StoryReducer.State(),
//            reducer: StoryReducer()
//        )
//        
//        store.dependencies.storyRepository.fetchRandomPhotoURLs = { _, _ in
//            throw APIError.networkError
//        }
//        
//        await store.send(.fetchPhotos(city: "Cupertino", count: 2)) {
//            $0.isLoading = true
//        }
//        
//        await store.receive(.photosResponse(.failure(APIError.networkError))) {
//            $0.isLoading = false
//            $0.errorMessage = "There was a network error while fetching the data."
//        }
//    }
//    
//    func testAdvanceStory() {
//        let store = TestStore(
//            initialState: StoryReducer.State(photoURLs: [
//                URL(string: "https://example.com/photo1.jpg")!,
//                URL(string: "https://example.com/photo2.jpg")!
//            ], currentStoryIndex: 0),
//            reducer: StoryReducer()
//        )
//        
//        store.send(.advanceStory) {
//            $0.currentStoryIndex = 1
//        }
//    }
//}
