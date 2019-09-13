//
//  ViewModel.swift
//  Vehicles
//
//  Created by m4m4 on 13.09.19.
//  Copyright © 2019 sina. All rights reserved.
//

import Foundation

class VeiclesManager {
    
    let api = VehicleAPI()
    
    func fetchAnnotations(cb: @escaping (Result<[VehicleAnnotationModel], API.APIServiceError>) -> Void) {
        api.fetch(from: .vehicles) { (result: Result<Array<Vehicle>, API.APIServiceError>) in
            switch result {
            case .success(let vehicleResponce):
                print("Success: \(vehicleResponce)")
                let result = vehicleResponce.map{ VehicleAnnotationModel(vehicle: $0)}
                DispatchQueue.main.async {
                     cb(.success(result))
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    cb(.failure(.noData))
                }
            }
        }
    }
}
