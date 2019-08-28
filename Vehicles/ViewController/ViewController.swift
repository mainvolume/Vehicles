//
//  ViewController.swift
//  Vehicles
//
//  Created by m4m4 on 28.08.19.
//  Copyright © 2019 sina. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit



struct MapAttributes {
    static let initialLocation = CLLocation(latitude: 52.5200, longitude: 13.4050)
    static let regionRadius: CLLocationDistance = 3000
   
}

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        centerMapOnLocation(location: MapAttributes.initialLocation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setLabeltext(text: "Loading")
        VehicleAPI.shared.fetchVehicles(from: .vehicles) { (result: Result<Array<Vehicle>, VehicleAPI.APIServiceError>) in
            switch result {
            case .success(let vehicleResponce):
                self.showViehicles(vehicles: vehicleResponce)
                self.setLabeltext(text: ": )")
            case .failure(let error):
                print(error.localizedDescription)
                self.setLabeltext(text: "Error")
            }
        }
    }
    
    func showViehicles(vehicles:[Vehicle]) {
        mapView.addAnnotations(vehicles.compactMap{ VehicleAnnotationModel(vehicle: $0)})
        mapView.reloadInputViews()
    }
    
    func setLabeltext(text:String) {
        DispatchQueue.main.async {
             self.loadingLabel.text = text
        }
    }
}


extension ViewController {
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: MapAttributes.regionRadius, longitudinalMeters: MapAttributes.regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? VehicleAnnotationModel else { return nil }
        let identifier = "vehicle"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
             view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
