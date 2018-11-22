//
//  PinClass.swift
//  YagnikPractical
//
//  Created by Yagnik Suthar on 22/11/18.
//  Copyright © 2018 Yagnik Suthar. All rights reserved.
//

import Foundation

import MapKit

class PinClass: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D ) {
        //        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
