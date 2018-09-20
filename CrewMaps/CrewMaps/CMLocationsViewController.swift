//
//  CLLocationsViewController.swift
//  CrewMapsApp
//
//  Created by OBES Cinco Rios on 18/09/2018.
//  Copyright © 2018 Crewlogix. All rights reserved.
//

import UIKit
import MapKit

@objc
public
protocol CrewMapsDataSource: CMLocationImageDataSource {
    @objc func annotationsForMap() -> [CMAnnotation]
}

class CMLocationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var dataSource: CrewMapsDataSource!
    
    var locations = [CMAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let titletView = UIImageView.init(image: #imageLiteral(resourceName: "nav_logo"))
        titletView.contentMode = .scaleAspectFit
        titletView.sizeToFit()
        navigationItem.titleView = titletView
        
        locations = dataSource.annotationsForMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CMLocationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        
        if let locationCell = cell as? CMMapTableViewCell {
            locationCell.dataSource = self
            let annotation = locations[indexPath.row]
            locationCell.configureWith(annotation)
        }
        
        return cell
    }
}

extension CMLocationsViewController: CMLocationImageDataSource {
    func defaultImageForAnnotations() -> UIImage {
        return dataSource.defaultImageForAnnotations()
    }
}
