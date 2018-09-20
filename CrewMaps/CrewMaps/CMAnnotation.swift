//
//  CMAnnotation.swift
//  CrewMapsApp
//
//  Created by OBES Cinco Rios on 18/09/2018.
//  Copyright © 2018 Crewlogix. All rights reserved.
//

import UIKit
import MapKit

public
class CMAnnotation: NSObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var subtitle: String?
    var image: UIImage?
    
    public
    init(lat: Double, long: Double, title: String?, subtitle: String?) {
        coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
        self.title = title
        self.subtitle = subtitle
    }
    
    public
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
