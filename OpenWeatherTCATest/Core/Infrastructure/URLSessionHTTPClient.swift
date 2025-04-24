//
//  URLSessionHTTPClient.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 22/04/2025.
//

import Foundation
import ComposableArchitecture

public struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    public func get(from request: URLRequest) async -> Result<(data: Data, response: HTTPURLResponse), Error> {
        do {
            let (data, response) = try await session.data(for: request, delegate: nil)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(UnexpectedValuesRepresentation())
            }
            return .success((data, httpResponse))
        } catch {
            return .failure(error)
        }
    }
}
