//
//  File.swift
//
//  Created by m4m4 on 02.08.19.
//  Copyright © 2019 sina. All rights reserved.
//

import Foundation


class VehicleAPI {
    
    
    // GiphyApi
    public static let shared = VehicleAPI()
    private init() {}
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://my-json-server.typicode.com/FlashScooters/Challenge")!
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    // Enums
    enum Endpoint: String, CustomStringConvertible, CaseIterable {
        var description: String { return "Endpoints" }
        case vehicles
    }
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    public func fetchVehicles(from endpoint: Endpoint, result: @escaping (Result<Array<Vehicle>, APIServiceError>) -> Void) {
        let giphyURL = baseURL
            .appendingPathComponent(endpoint.rawValue)
        decodableDataTask(url: giphyURL, completion: result)
    }

}


extension VehicleAPI {
    
    private func decodableDataTask<T: Decodable>(url: URL, queryItems:[URLQueryItem] = [], completion: @escaping (Result<T, APIServiceError>) -> Void) {
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch (let error){
                    print(error)
                    completion(.failure(.decodeError))
                }
            case .failure(_):
                completion(.failure(.apiError))
            }
            }.resume()
    }
}
