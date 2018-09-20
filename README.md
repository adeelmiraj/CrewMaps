# CrewMaps
An iOS framework to integrate maps in your application.

Integration Instructions
---------
> Download the project somewhere on your disk.
> Open the Xcode project you want to use this framework in.
> Right-click on the root `CrewMapsApp` node in the project navigator. Click Add Files to “CrewMapsApp”. In the file chooser, navigate to and select CrewMaps.xcodeproj. Click Add to add CrewMaps.xcodeproj as a sub-project. "Make sure that the project is not open in Xcode while you are adding it as a dependency."
![Animated Screenshot](https://raw.githubusercontent.com/bfeher/BFPaperTableViewCell/master/BFPaperTableViewCellDemoGif.gif "Animated Screenshot")

> Select the top level CrewMapsApp node to open the project editor. Click the CrewMapsApp target, and then go to the General tab.
> Scroll down to the Embedded Binaries section. Drag CrewMaps.framework from the Products folder of CrewMaps.xcodeproj onto this section.
> You just added an entry for the framework in both Embedded Binaries and Linked Frameworks and Binaries.
![Animated Screenshot](https://raw.githubusercontent.com/bfeher/BFPaperTableViewCell/master/BFPaperTableViewCellDemoGif.gif "Animated Screenshot")


## Protocols
Use following protocols to pass data to the framework.

CMTabBarDataSource
CMMapViewControllerDataSource
CrewMapsDataSource
CMLocationImageDataSource
---------
You need to implement this protocol. In fact if you conform to this protocol you conform to all other protocols too. You'll be interacting with the `CMTabBarController` only. The framework will take care of all other stuff itself.

`var currentLocation: CLLocation { get }` 
> Provide the current locations of the user.

`func annotationsForMap() -> [CMAnnotation]`
> Provide annotations to mark the pins on the map for the user.

`func titleViewForViewController() -> UIView`
> This is optional. If you want to show a custom title view in the in the navigation bar then implement this method and return a view of your liking.

`func defaultImageForAnnotations() -> UIImage`
> Default pin image to show on the map.

`func imageForAnnotation(_ annotation: CMAnnotation) -> UIImage`
> This method is also optional. If implemented the the image returned by this method is used as the pin image otherwise the default image.


## Usage
The sample project in the repository shows how to use the framework in a project. You can run and see it for yourself.

### Example
```Swift
// Instantiate the CMTabBarController and add as a child view controller to your view controller

let bundle = Bundle.init(for: CMTabBarController.self)
let storyboard = UIStoryboard.init(name: "Main", bundle: bundle)
let tabBarController = storyboard.instantiateInitialViewController() as! CMTabBarController
tabBarController.mapsDataSource = self
self.addChildViewController(tabBarController)
tabBarController.didMove(toParentViewController: self)
self.view.addSubview(tabBarController.view)
tabBarController.view.frame = self.view.bounds



// Implement the `CMTabBarDataSource`

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
```
