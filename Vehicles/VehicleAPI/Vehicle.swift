//
//  Giphy.swift
//
//  Created by m4m4 on 02.08.19.
//  Copyright © 2019 sina. All rights reserved.
//

import Foundation


struct Vehicle: Codable {
    let id: Int
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    let batteryLevel: Int
    let price: Int
    let priceTime: Int
    let currency: String
}
