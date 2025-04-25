//
//  HTTPClient.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 22/04/2025.
//

import Foundation
import ComposableArchitecture

// MARK: - HTTPClient Protocol
public protocol HTTPClient {
    func get(from request: URLRequest) async -> Result<(data: Data, response: HTTPURLResponse), Error>
}

// MARK: - Dependency Key

extension DependencyValues {
    var httpClient: HTTPClient {
        get { self[HTTPClientKey.self] }
        set { self[HTTPClientKey.self] = newValue }
    }
    
    private struct HTTPClientKey: DependencyKey {
        static let liveValue: HTTPClient = URLSessionHTTPClient(session: .shared)
    }
}


// MARK: - Mock HTTPClient (for Testing)
public struct MockHTTPClient: HTTPClient {
    public var getHandler: (URLRequest) async -> Result<(data: Data, response: HTTPURLResponse), Error>

    public func get(from request: URLRequest) async -> Result<(data: Data, response: HTTPURLResponse), Error> {
        await getHandler(request)
    }
}

// MARK: - Error Representation
public struct UnexpectedValuesRepresentation: Error {}
