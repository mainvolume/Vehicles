//
//  vehicleViewModel.swift
//  Vehicles
//
//  Created by m4m4 on 15.09.19.
//  Copyright © 2019 sina. All rights reserved.
//

import Foundation

protocol ViehicleViewModelDelegate: class {
    func loadingTextUpdated(text:String)
    func annotaitonsUpdated(annotatitons:[VehicleAnnotationModel])
}

class VeihicleViewModel {
    
    enum loadinResults: String {
        case initial = "Hello"
        case loading = "loading"
        case loaded = "😍"
        case error = "Error, no veihicles"
    }
    
    let api = VehicleAPI()
    
    weak var delegate:ViehicleViewModelDelegate?
    
    var mapAnotaions: [VehicleAnnotationModel] = [] {
        didSet {
            delegate?.annotaitonsUpdated(annotatitons: mapAnotaions)
        }
    }
    
    var loadingText: String = loadinResults.initial.rawValue {
        didSet {
            delegate?.loadingTextUpdated(text: loadingText)
        }
    }
    
    func fetchAnnotations() {
        self.loadingText = loadinResults.initial.rawValue
        api.fetch(from: .vehicles) { (result: Result<Array<Vehicle>, API.APIServiceError>) in
            switch result {
            case .success(let vehicleResponce):
                print("Success: \(vehicleResponce)")
                let result = vehicleResponce.map{ VehicleAnnotationModel(vehicle: $0)}
                DispatchQueue.main.async {
                    self.loadingText = loadinResults.loaded.rawValue
                    self.delegate?.annotaitonsUpdated(annotatitons: result)
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.loadingText = loadinResults.error.rawValue
                }
            }
        }
    }
}
