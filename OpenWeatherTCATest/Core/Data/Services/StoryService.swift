//
//  StoryService.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 25/04/2025.
//

import Foundation
import ComposableArchitecture

struct StoryService: StoryRepositoryProtocol {
    func fetchRandomPhotoURLs(for city: String, with photosCount: Int) async throws -> [URL] {
        let baseUrlString = "https://api.unsplash.com/photos/random"

        let dataTransferService = DefaultDataTransferService(
            networkService: URLSessionHTTPClient(session: .shared)
        )

        // Use count parameter to fetch multiple photos in a single request
        var components = URLComponents(string: baseUrlString)!
        components.queryItems = [
            URLQueryItem(name: "query", value: city),
            URLQueryItem(name: "orientation", value: "portrait"),
            URLQueryItem(name: "count", value: "\(photosCount)")
        ]

        guard let requestUrl = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: requestUrl)
        request.setValue("Client-ID \(APIKeys.Unsplash)", forHTTPHeaderField: "Authorization")

        // When count > 1, API returns an array of photos
        let result: Result<[UnsplashPhoto], Error> = await dataTransferService.request(from: request)

        switch result {
        case let .success(photos):
            let urls = photos.compactMap { URL(string: $0.urls.regular) }
#if DEBUG
            print("📸 Unsplash API returned \(photos.count) photos (requested: \(photosCount))")
            print("📸 Successfully parsed \(urls.count) URLs")
            // If we got fewer photos than requested, it might be due to limited search results
            if photos.count < photosCount {
                print("⚠️ Warning: API returned fewer photos than requested. Query: '\(city)' may have limited results.")
            }
#endif
            return urls
        case let .failure(error):
            throw mapError(error)
        }
    }
    
    private func mapError(_ error: Error) -> StoryAPIClientError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .badURL:
                return .invalidURL
            case .cannotLoadFromNetwork:
                return .networkError
            default:
                return .unknown
            }
        } else if let _ = error as? DecodingError {
            return .decodingFailed
        } else {
            return .unknown
        }
    }
    
    enum StoryAPIClientError: Error, Equatable {
        case invalidURL
        case networkError
        case decodingFailed
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "The URL provided is invalid."
            case .networkError:
                return "There was a network error while fetching the data."
            case .decodingFailed:
                return "Failed to decode the data from the server."
            case .unknown:
                return "An unknown error occurred."
            }
        }
    }
    
}

// MARK: - DependencyValues Integration

extension DependencyValues {
    var storyRepository: StoryRepositoryProtocol {
        get { self[StoryRepositoryKey.self] }
        set { self[StoryRepositoryKey.self] = newValue }
    }
}

private enum StoryRepositoryKey: DependencyKey {
    static let liveValue: StoryRepositoryProtocol = StoryService()
    static let testValue: StoryRepositoryProtocol = MockStoryService()
}
