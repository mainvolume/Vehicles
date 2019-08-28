//
//  VehiclesTests.swift
//  VehiclesTests
//
//  Created by m4m4 on 28.08.19.
//  Copyright © 2019 sina. All rights reserved.
//

import XCTest
@testable import Vehicles

class VehiclesTests: XCTestCase {
    
    func loadJson(filename fileName: String) -> [Vehicle]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Array<Vehicle>.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

    func testUnitVehicles() {
        guard let vehicles = loadJson(filename: "vehicle_mock") else {
            XCTFail("Error loading resource")
            return
        }
        XCTAssert(vehicles.count > 0)
    }

    
    
    func testIntegerationFetchVehicles() {
        let expectation = self.expectation(description: "Downloading")
        VehicleAPI.shared.fetchVehicles(from: .vehicles) { (result: Result<Array<Vehicle>, VehicleAPI.APIServiceError>) in
            switch result {
            case .success(let vehicleResponce):
                print(vehicleResponce)
                XCTAssert(vehicleResponce.count > 0)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                
                XCTFail("Error loading resource")
                expectation.fulfill()
            }
        }
        // Wait for the expectation to be fullfilled, or time out
        // after 5 seconds. This is where the test runner will pause.
        waitForExpectations(timeout: 5, handler: nil)
    }

}
