//
//  File.swift
//
//  Created by m4m4 on 02.08.19.
//  Copyright © 2019 sina. All rights reserved.
//

import Foundation


class VehicleAPI {

    let api = API()
    
    public enum BaseUrls: String {
        case challenge = "https://my-json-server.typicode.com/FlashScooters/Challenge"
    }
    
    enum Endpoint: String, CustomStringConvertible, CaseIterable {
        var description: String { return "Endpoints" }
        case vehicles
    }
    
    func fetch(from endpoint: Endpoint, result: @escaping (Result<Array<Vehicle>, API.APIServiceError>) -> Void) {
        guard let baseURL = URL(string: BaseUrls.challenge.rawValue) else {
            result(.failure(.invalidEndpoint))
            return
        }
        let url = baseURL.appendingPathComponent(endpoint.rawValue)
        api.decodableDataTask(url: url, completion: result)
    }
}
