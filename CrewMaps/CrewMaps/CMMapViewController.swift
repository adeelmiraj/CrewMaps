//
//  CMMapViewController.swift
//  CrewMapsApp
//
//  Created by OBES Cinco Rios on 18/09/2018.
//  Copyright © 2018 Crewlogix. All rights reserved.
//

import UIKit
import MapKit

@objc
public
protocol CMMapViewControllerDataSource: CrewMapsDataSource {
    var currentLocation: CLLocation { get }
}

class CMMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView?
    
    @IBOutlet weak var dataSource: CMMapViewControllerDataSource!
    
    var userLocation: CLLocation! {
        get {
            return dataSource.currentLocation
        }
    }
    
    private let identifier = "marker"
    private var defaultImage = #imageLiteral(resourceName: "map_pin")
    private var annotations = [CMAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let titleView: UIView
        if dataSource.responds(to: #selector(CrewMapsDataSource.titleViewForViewController)) {
            titleView = dataSource.titleViewForViewController!()
        }
        else {
            let image = UIImage.init(named: "nav_logo",
                                     in: Bundle.init(for: self.classForCoder),
                                     compatibleWith: nil)
            let imageView = UIImageView.init(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.sizeToFit()
            titleView = imageView
        }
        
        navigationItem.titleView = titleView
        
        mapView?.delegate = self
        
        annotations = dataSource.annotationsForMap()
        
        if let datasource = dataSource,
            datasource.responds(to: #selector(CMMapViewControllerDataSource.defaultImageForAnnotations)) {
            defaultImage = datasource.defaultImageForAnnotations()
        }
        
        centerMapOnLocation(location: userLocation)
        
        mapView?.addAnnotations(annotations)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let regionRadius: CLLocationDistance = 500
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView?.setRegion(coordinateRegion, animated: false)
    }
}

extension CMMapViewController: MKMapViewDelegate {
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
        
        if dataSource.responds(to: #selector(CMMapViewControllerDataSource.imageForAnnotation)) {
            let annotationImage = dataSource.imageForAnnotation!(annotation)
            view.image = annotationImage
        }
        else {
            view.image = defaultImage
        }
        
        return view
    }
}

