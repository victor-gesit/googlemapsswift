//
//  ViewController.swift
//  MapsDemoSwift
//
//  Created by Victor Idongesit on 28/02/2018.
//  Copyright © 2018 Victor Idongesit. All rights reserved.
//

import UIKit
import GoogleMaps

class CommonLocations {
    let name: String
    let location: CLLocationCoordinate2D
    let zoom: Float
    let snippet: String?
    convenience init(name: String, location: (Double, Double), zoom: Float) {
        self.init(name, location, zoom, nil)
    }
    init(_ name: String, _ location: (Double, Double), _ zoom: Float, _ snippet: String?) {
        self.name = name
        self.location = CLLocationCoordinate2D(latitude: location.0, longitude: location.1)
        self.zoom = zoom
        self.snippet = snippet
    }
}
class ViewController: UIViewController {
    var mapView: GMSMapView?
    var locations: [CommonLocations]?
    var currentLocation: CommonLocations?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        populateLocations()
        GMSServices.provideAPIKey("AIzaSyAUevcsBz-onINR-lhCF9aJ9V747oIYVL4")
        let camera = GMSCameraPosition.camera(withLatitude: 6.553908, longitude: 3.366222, zoom: 15)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        let currentLocation = CLLocationCoordinate2D(latitude: 6.553908, longitude: 3.366222)
        let marker = GMSMarker(position: currentLocation)
        marker.map = mapView
        marker.title = "Andela Epic Tower"
        marker.snippet = "Work"
        view = mapView;
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(ViewController.next as (ViewController) -> () -> ()))
    }
    
    @objc
    private func next() {
        if currentLocation == nil {
            currentLocation = locations?.last
        } else {
            let index = locations?.index { $0 === currentLocation }
            if var index = index, let count = locations?.count {
                print("Index alone: ", index)
                index = index + 1
                index = index % (count)
                print("This index", index, count)
                currentLocation = locations![index]
            }
        }
        setMapCamera()

    }
    private func populateLocations() {
        
        let work = CommonLocations("Andela Epic Tower", (6.553908, 3.366222), 20, "Work")
        let home = CommonLocations("Amity 2.0", (6.569862, 3.373229), 20, "Home")
        let amity1 = CommonLocations(name: "Amity 1.0", location: (6.506920, 3.383960), zoom: 20)
        let locations: [CommonLocations] = [work, home, amity1]
        self.locations = locations
    }
    
    private func setMapCamera() {
        
        let camera = GMSCameraPosition.camera(withTarget: currentLocation!.location, zoom: currentLocation!.zoom)
        
        let nextMarker = GMSMarker(position: currentLocation!.location)
        nextMarker.title = currentLocation!.name
        nextMarker.snippet = currentLocation!.snippet
        nextMarker.map = mapView
        
        
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        mapView?.animate(to: camera)
        CATransaction.commit()
    }

}

