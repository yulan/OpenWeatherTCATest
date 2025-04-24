//
//  DefaultDataTransferService.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 22/04/2025.
//

import Foundation
import ComposableArchitecture

public final class DefaultDataTransferService: DataTransferService {
    public let networkService: HTTPClient
    
    public init(networkService: HTTPClient) {
        self.networkService = networkService
    }
    
    private static var OK_200: Int { return 200 }
    
    public func request<T: Decodable>(from request: URLRequest) async -> Result<T, Error> {
        do {
            let result: Result<(data: Data, response: HTTPURLResponse), Error> = await networkService.get(from: request)
            
            switch result {
            case let .success((data, response)):
                if response.statusCode == DefaultDataTransferService.OK_200 {
                    return self.decode(data: data)
                } else {
                    return .failure(DataTransferError.networkFailure)
                }
            case let .failure(error):
                return .failure(error)
            }
        }
    }
    
    private func decode<T: Decodable>(data: Data?) -> Result<T, Error> {
        do {
            guard let data = data else { return .failure(DataTransferError.noResponse) }
            let result: T = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - Mock DataTransferService (for Testing)
struct MockDataTransferService: DataTransferService {
    var requestHandler: (URLRequest) async -> Result<Data, Error>
    
    func request<T: Decodable>(from request: URLRequest) async -> Result<T, Error> {
        do {
            let result = await requestHandler(request)
            switch result {
            case let .success(data):
                let decoded: T = try JSONDecoder().decode(T.self, from: data)
                return .success(decoded)
            case let .failure(error):
                return .failure(error)
            }
        } catch {
            return .failure(error)
        }
    }
}
