//
//  LocationModel.swift
//  YagnikPractical
//
//  Created by Yagnik Suthar on 22/11/18.
//  Copyright © 2018 Yagnik Suthar. All rights reserved.
//

import Foundation

import UIKit
import CoreData


class LocationModel {
    let name: String
    let vicinity: String
    let iconName: String
    let lat: Double
    let lon: Double
    
    init(name: String, vicinity: String, iconName: String, lat: Double,lon: Double) {
        self.name = name
        self.vicinity = vicinity
        self.iconName = iconName
        self.lat = lat
        self.lon = lon
    }
}

