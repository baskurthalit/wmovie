//
//  WMovieNetwork.swift
//
//
//  Created by Halit Baskurt on 19.06.2024.
//

import Foundation

public enum ErrorResponse: Error {
    case statusCode
    case decodingError
    case taskError
    case requestFailed
}

public protocol WMovieNetworkInterface {
    func request<R>(for endpoint: Endpoint, completion: @escaping (Result<R, ErrorResponse>) -> Void) where R : Codable
    func request<R>(for endpoint: Endpoint) async throws -> R? where R: Codable
}

public class WMovieNetwork: WMovieNetworkInterface {
    
    private let session: URLSession
    private var jsonDecoder = JSONDecoder()
    
    public init() {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 60
        config.requestCachePolicy = .reloadRevalidatingCacheData
        session = .init(configuration: config)
    }
    
    public func request<R>(for endpoint: Endpoint, completion: @escaping (Result<R, ErrorResponse>) -> Void) where R : Codable {
        guard let request = endpoint.request else {
            debugPrint(ErrorResponse.requestFailed)
            completion(.failure(.requestFailed))
            return
        }
        debugPrint(endpoint)
        session.dataTask(with: request) { [weak self](data, urlResponse, error) in
            self?.dataTaskHandler(data, urlResponse, error, completion: completion)
        }.resume()
    }
    
    public func request<R>(for endpoint: Endpoint) async throws -> R? where R: Codable {
        guard let request = endpoint.request else { return nil }
        let (data, response) = try await makeRequest(for: request)
        return try handleResponse(data, response)
    }
    
    private func dataTaskHandler<R: Codable>(_ data: Data?,
                                             _ response: URLResponse?,
                                             _ error: Error?,
                                             completion: @escaping (Result<R, ErrorResponse>) -> Void) {
        if error != nil {
            debugPrint("Task handling error: \(String(describing: error))")
            completion(.failure( ErrorResponse.taskError ))
        } else if let data, let response{
            do {
                let decodedData: R = try handleResponse(data, response)
                debugPrint(data.prettyPrintedJSONString as Any)
                completion(.success(decodedData))
            } catch {
                completion(.failure( .decodingError ))
            }
        }
    }
    
    private func makeRequest(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response) = try await session.data(for: urlRequest)
        return (data, response)
    }
    
    private func handleResponse<R: Codable>(_ data: Data, _ response: URLResponse) throws -> R {
        if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
            return try decodeResponse(data)
        } else {
            throw ErrorResponse.statusCode
        }
    }
    
    private func decodeResponse<R: Codable>(_ data: Data) throws -> R {
        return try jsonDecoder.decode(R.self, from: data)
    }  
}
