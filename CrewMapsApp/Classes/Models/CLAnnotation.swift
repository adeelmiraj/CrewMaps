//
//  CLAnnotation.swift
//  CrewMapsApp
//
//  Created by OBES Cinco Rios on 18/09/2018.
//  Copyright © 2018 Crewlogix. All rights reserved.
//

import UIKit
import MapKit

class CLAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(lat: Double, long: Double, title: String?, subtitle: String?) {
        coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
        self.title = title
        self.subtitle = subtitle
    }
}
