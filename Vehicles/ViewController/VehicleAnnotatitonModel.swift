//
//  VehicleAnnotatitonModel.swift
//  Vehicles
//
//  Created by m4m4 on 28.08.19.
//  Copyright © 2019 sina. All rights reserved.
//

import MapKit

class VehicleAnnotationModel: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let name: String
    let descr: String
    let batteryLevel: Int
    let price: Int
    let priceTime: Int
    let currency: String
    
    init(vehicle:Vehicle) {
        self.name = vehicle.name
        self.descr = vehicle.description
        self.batteryLevel = vehicle.batteryLevel
        self.price = vehicle.price
        self.priceTime = vehicle.priceTime
        self.currency = vehicle.currency
        self.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
        
        super.init()
    }
    
    var title: String? {
        return self.descr
    }
    
    var subtitle: String? {
        return "\(self.price)" + self.currency + "/\(self.priceTime) minutes"
    }
}
