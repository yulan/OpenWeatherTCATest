//
//  Untitled.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 25/04/2025.
//

import Foundation

struct MockStoryService: StoryRepositoryProtocol {
    var fetchRandomPhotoURLsHandler: (String, Int) async throws -> [URL] = { _, _ in
        return [
            URL(string: "https://example.com/photo1.jpg")!,
            URL(string: "https://example.com/photo2.jpg")!,
            URL(string: "https://example.com/photo3.jpg")!
        ]
    }

    func fetchRandomPhotoURLs(for city: String, with photosCount: Int) async throws -> [URL] {
        try await fetchRandomPhotoURLsHandler(city, photosCount)
    }
}

// MARK: - Predefined Mock Configurations

extension MockStoryService {
    static let successMock = MockStoryService(
        fetchRandomPhotoURLsHandler: { city, photosCount in
            guard photosCount > 0 else { return [] }
            return (1...photosCount).map { index in
                URL(string: "https://example.com/\(city)_photo\(index).jpg")!
            }
        }
    )
    
    static let failureMock = MockStoryService(
        fetchRandomPhotoURLsHandler: { _, _ in
            throw URLError(.cannotLoadFromNetwork)
        }
    )
}
