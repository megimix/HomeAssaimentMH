//
//  NetworkService.swift
//  HomeAssaimentMH
//
//  Created by Tal Shachar on 29/01/2023.
//

import Foundation
import Combine

enum NetworkServiceError: Error {
    case invalidURL
    case decodingError(String)
    case genericError(String)
    case invalidResponseCode(Int)
    
    var errorMessageString: String {
        switch self {
        case .invalidURL:
            return "Invalid URL encountered. Can't proceed with the request"
        case .decodingError:
            return "Encountered an error while decoding incoming server response. The data couldn’t be read because it isn’t in the correct format."
        case .genericError(let message):
            return message
        case .invalidResponseCode(let responseCode):
            return "Invalid response code encountered from the server. Expected 200, received \(responseCode)"
        }
    }
}

final class NetworkService {
    
    let urlSession: URLSession
    let baseURLString: String
    
    init(urlSession: URLSession = .shared, baseURLString: String) {
        self.urlSession = urlSession
        self.baseURLString = baseURLString
    }
    
    func getPublisherForResponse<T: Decodable>(endpoint: String, queryParameters: [String: String]) -> AnyPublisher<T, NetworkServiceError> {

        let queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
        
        let urlComponents = NSURLComponents(string: baseURLString + endpoint)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            return Fail(error: NetworkServiceError.invalidURL).eraseToAnyPublisher()
        }
        print("URL: \(url)")
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    guard (200..<300) ~= httpResponse.statusCode else {
                        throw NetworkServiceError.invalidResponseCode(httpResponse.statusCode)
                    }
                }
                return data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: T.self, decoder: {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return decoder
            }())
            .mapError { error -> NetworkServiceError in
                if let decodingError = error as? DecodingError {
                    return NetworkServiceError.decodingError((decodingError as NSError).debugDescription)
                }
                return NetworkServiceError.genericError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

