//
//  Story.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 25/04/2025.
//

import Foundation

public struct Story: Equatable {
    let imageURL: URL
}

public struct UnsplashPhoto: Decodable {
    let urls: Urls
    struct Urls: Decodable {
        let regular: String
    }
}
