//
//  CMTabBarController.swift
//  CrewMapsApp
//
//  Created by OBES Cinco Rios on 19/09/2018.
//  Copyright © 2018 Crewlogix. All rights reserved.
//

import UIKit
import CoreLocation

@objc
public protocol CMTabBarDataSource: CMMapViewControllerDataSource {
    
}

public
class CMTabBarController: UITabBarController {

    public weak var mapsDataSource: CMTabBarDataSource!
    
    private var annotations = [CMAnnotation]()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
//        if let mapVC = viewControllers?.first as? CMMapViewController {
//            mapVC.dataSource = self
//        }
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "CMMapViewController") as! CMMapViewController
        mapVC.dataSource = self
        let mapItem = UITabBarItem.init(title: "Map", image: nil, tag: 0)
        mapItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -16)
        let mapNavController = UINavigationController.init(rootViewController: mapVC)
        mapNavController.setNavigationBarHidden(false, animated: false)
        mapNavController.tabBarItem = mapItem
        
        let locationsVC = storyboard?.instantiateViewController(withIdentifier: "CMLocationsViewController") as! CMLocationsViewController
        locationsVC.dataSource = self
        let locationItem = UITabBarItem.init(title: "Locations", image: nil, tag: 1)
        locationItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -16)
        let locNavController = UINavigationController.init(rootViewController: locationsVC)
        locNavController.setNavigationBarHidden(false, animated: false)
        locNavController.tabBarItem = locationItem
        let viewControllers = [mapNavController, locNavController]
        self.viewControllers = viewControllers
    }
}

extension CMTabBarController: CMMapViewControllerDataSource {
    public var currentLocation: CLLocation {
        return mapsDataSource.currentLocation
    }
    
    public func defaultImageForAnnotations() -> UIImage {
        return mapsDataSource.defaultImageForAnnotations()
    }
    
    public func annotationsForMap() -> [CMAnnotation] {
        annotations = mapsDataSource.annotationsForMap()
        return annotations
    }
}
