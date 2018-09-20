//
//  CMMapTableViewCell.swift
//  CrewMapsApp
//
//  Created by OBES Cinco Rios on 20/09/2018.
//  Copyright © 2018 Crewlogix. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

@objc
protocol CMLocationImageDataSource: NSObjectProtocol {
    @objc func defaultImageForAnnotations() -> UIImage
    @objc optional func imageForAnnotation(_ annotation: CMAnnotation) -> UIImage
}

class CMMapTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?
    @IBOutlet weak var mapView: MKMapView?

    weak var dataSource: CMLocationImageDataSource!
    
    private let identifier = "marker"
    var defaultImage: UIImage!
    
    var annotation: CMAnnotation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView?.layer.borderColor = UIColor.darkGray.cgColor
        containerView?.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(_ anAnnotation: CMAnnotation) {
        self.annotation = anAnnotation
        
        if defaultImage == nil {
            defaultImage = dataSource.defaultImageForAnnotations()
        }
        
        if let annotations = mapView?.annotations {
            mapView?.removeAnnotations(annotations)
        }
        
        titleLabel?.text = annotation?.title
        addressLabel?.text = annotation?.subtitle
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(anAnnotation.coordinate,
                                                                  50, 50)
        mapView?.setRegion(coordinateRegion, animated: false)
        mapView?.addAnnotation(anAnnotation)
    }
}

extension CMMapTableViewCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CMAnnotation else { return nil }
        var view: MKAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
        }
        
        if dataSource.responds(to: #selector(CMLocationImageDataSource.imageForAnnotation)) {
            let annotationImage = dataSource.imageForAnnotation!(annotation)
            view.image = annotationImage
        }
        else {
            view.image = defaultImage
        }
        
        return view
    }
}
