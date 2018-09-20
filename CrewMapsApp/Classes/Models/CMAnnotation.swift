//
//  CMAnnotation.swift
//  CrewMapsApp
//
//  Created by OBES Cinco Rios on 18/09/2018.
//  Copyright © 2018 Crewlogix. All rights reserved.
//

import UIKit
import MapKit

class CMAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    
    init(lat: Double, long: Double, title: String?, subtitle: String?) {
        coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
        self.title = title
        self.subtitle = subtitle
    }
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
