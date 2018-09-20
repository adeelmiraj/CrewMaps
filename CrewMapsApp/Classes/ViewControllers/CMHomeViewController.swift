//
//  CMHomeViewController.swift
//  CrewMapsApp
//
//  Created by OBES Cinco Rios on 19/09/2018.
//  Copyright © 2018 Crewlogix. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class CMHomeViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    private let locationManager = CLLocationManager()
    private var _currentLocation: CLLocation!
    private var searchedTypes = ["bakery", "cafe", "grocery_or_supermarket", "restaurant"]
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1000
    
    var childVC: CMTabBarController?
    var places = [GooglePlace]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.bringSubview(toFront: activityIndicator!)
        
        guard let tabBarController = childVC else { return }
        tabBarController.view.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(searchRadius)&rankby=prominence&sensor=true&key=\(googleApiKey)"
        let typesString = searchedTypes.count > 0 ? searchedTypes.joined(separator: "|") : "food"
        urlString += "&types=\(typesString)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        activityIndicator?.startAnimating()
        
        let request = Alamofire.request(url)
        request.responseJSON { [unowned self] (response) in
            
            self.activityIndicator?.stopAnimating()
            
            guard response.result.isSuccess else {
                return
            }
            
            guard let value = response.result.value as? [String: Any] else { return }
            guard let results = value["results"] as? [[String: Any]] else { return }
            
            var placesArray = [GooglePlace]()
            for aPlace in results {
                print(aPlace)
                let place = GooglePlace(dictionary: aPlace, acceptedTypes: self.searchedTypes)
                placesArray.append(place)
//                if let reference = place.photoReference {
//                    self.fetchPhotoFromReference(reference) { image in
//                        place.photo = image
//                    }
//                }
            }
            
            self.places = placesArray
            
            if self.childVC == nil {
                let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "CMTabBarController") as! CMTabBarController
                tabBarController.mapsDataSource = self
                self.addChildViewController(tabBarController)
                tabBarController.didMove(toParentViewController: self)
                self.view.addSubview(tabBarController.view)
                tabBarController.view.frame = self.view.bounds
            }
        }
        /*
        dataProvider.fetchPlacesNearCoordinate(coordinate,
                                               radius:searchRadius,
                                               types: searchedTypes) { [unowned self] places in
                                                
                                                if self.childVC == nil {
                                                    let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "CMTabBarController") as! CMTabBarController
                                                    self.addChildViewController(tabBarController)
                                                    tabBarController.didMove(toParentViewController: self)
                                                    self.view.addSubview(tabBarController.view)
                                                    tabBarController.view.frame = self.view.bounds
                                                }
                                                
                                                places.forEach {
                                                    let _ = PlaceMarker(place: $0)
//                                                    marker.map = self.mapView
                                                }
        }
         */
    }
}

extension CMHomeViewController: CMTabBarDataSource {
    var currentLocation: CLLocation {
        return _currentLocation
    }
    
    func defaultImageForAnnotations() -> UIImage {
        return #imageLiteral(resourceName: "map_pin")
    }
    
    func annotationsForMap() -> [CMAnnotation] {
        var annotations = [CMAnnotation]()
        for place in places {
            let annotation = CMAnnotation.init(coordinate: place.coordinate,
                                               title: place.name,
                                               subtitle: place.address)
            annotations.append(annotation)
        }
        
        return annotations
    }
}

extension CMHomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        self._currentLocation = location
        locationManager.stopUpdatingLocation()
        fetchNearbyPlaces(coordinate: location.coordinate)
    }
}
