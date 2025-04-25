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
        var urls: [URL] = []
        
        let accessKey = "McCblZG0wBxB-8axocAtXw1XB0CVtxYBS_iLM4BrvYk"
        let baseUrlString = "https://api.unsplash.com/photos/random"
        
        let dataTransferService = DefaultDataTransferService(
            networkService: URLSessionHTTPClient(session: .shared)
        )

        for _ in 0..<photosCount {
            var components = URLComponents(string: baseUrlString)!
            components.queryItems = [
                URLQueryItem(name: "query", value: city),
                URLQueryItem(name: "orientation", value: "portrait")
            ]

            guard let requestUrl = components.url else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: requestUrl)
            request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")

            let result: Result<UnsplashPhoto, Error> = await dataTransferService.request(from: request)

            switch result {
            case .success(let photo):
                if let url = URL(string: photo.urls.regular) {
                    urls.append(url)
                }
            case .failure:
                throw URLError(.cannotLoadFromNetwork)
            }
        }

        return urls
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
