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
    static let annotaionOffset: CGPoint = CGPoint(x: -5, y: 5)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    var viewModel = VeihicleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        if let map = mapView {
            map.delegate = self
            centerLocationOn(map, location: MapAttributes.initialLocation)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchAnnotations()
    }
}

extension ViewController: ViehicleViewModelDelegate {
    
    func loadingTextUpdated(text: String) {
         loadingLabel?.text = text
    }
    
    func annotaitonsUpdated(annotatitons: [VehicleAnnotationModel]) {
        if let map = mapView {
            showViehcles(map, annotatitons: annotatitons)
        }
    }
}


extension ViewController: MKMapViewDelegate {
    
    func showViehcles(_ mapView: MKMapView, annotatitons:[VehicleAnnotationModel]) {
        mapView.addAnnotations(annotatitons)
        mapView.reloadInputViews()
    }
    
    func centerLocationOn(_ mapView: MKMapView, location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: MapAttributes.regionRadius, longitudinalMeters: MapAttributes.regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? VehicleAnnotationModel else { return nil }
        let identifier = "vehicle"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = MapAttributes.annotaionOffset
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
