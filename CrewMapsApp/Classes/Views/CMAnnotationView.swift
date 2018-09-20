//
//  CMAnnotationView.swift
//  CrewMapsApp
//
//  Created by OBES Cinco Rios on 18/09/2018.
//  Copyright © 2018 Crewlogix. All rights reserved.
//

import UIKit
import MapKit

class CMAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        didSet {
            // 1
            guard let newValue = annotation as? CMAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
//            image = newValue.image
//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            // 2
//            markerTintColor = newValue.markerTintColor
//            glyphText = String(newValue.discipline.first!)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
