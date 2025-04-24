//
//  DataTransferService.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 22/04/2025.
//

import Foundation
import ComposableArchitecture

// MARK: - DataTransferError
public enum DataTransferError: Error {
    case noResponse
    case networkFailure
}

// MARK: - ResponseDecoder Protocol
public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

// MARK: - DataTransferService Protocol
public protocol DataTransferService {
    func request<T: Decodable>(from request: URLRequest) async -> Result<T, Error>
}

// MARK: - Dependency Key
extension DependencyValues {
    var dataTransferService: DataTransferService {
        get { self[DataTransferServiceKey.self] }
        set { self[DataTransferServiceKey.self] = newValue }
    }
    
    private struct DataTransferServiceKey: DependencyKey {
        static let liveValue: DataTransferService = DefaultDataTransferService(
            networkService: URLSessionHTTPClient(session: .shared)
        )
    }
}
