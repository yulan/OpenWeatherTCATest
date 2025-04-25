//
//  StoryRepository.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 25/04/2025.
//

import Foundation

protocol StoryRepositoryProtocol {
    func fetchRandomPhotoURLs(for city: String, with photosCount: Int) async throws -> [URL]
}
