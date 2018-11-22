//
//  DetailsVC.swift
//  YagnikPractical
//
//  Created by Yagnik Suthar on 22/11/18.
//  Copyright © 2018 Yagnik Suthar. All rights reserved.
//

import UIKit
import MapKit

class DetailsVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    public var objLocationModel : LocationModel?
    var coordinate : CLLocationCoordinate2D?
    
    let initialLocation = CLLocation(latitude: 23.0345116, longitude: 72.5063882)
    let regionRadius: CLLocationDistance = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.mapView.delegate = self as! MKMapViewDelegate
        centerMapOnLocation(location: initialLocation)
        
//        if let cordinate = coordinate {
//            mapView.centerCoordinate = cordinate
//        }
        
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
}

extension DetailsVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PinClass else { return nil }
        var view: MKMarkerAnnotationView
        let identifier = "marker"
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
