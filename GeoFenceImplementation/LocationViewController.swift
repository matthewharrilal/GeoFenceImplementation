//
//  ViewController.swift
//  GeoFenceImplementation
//
//  Created by Matthew Harrilal on 3/31/18.
//  Copyright © 2018 Matthew Harrilal. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

class LocationViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        currentLocation = locationManager.location
        // This is the function that handles the did update location
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), span)
        mapView.setRegion(region, animated: true)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LocationViewController.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        annotation.title = "Pin \(self.mapView.annotations.count)"
        print(annotation.coordinate.latitude, annotation.coordinate.longitude)
        self.mapView.addAnnotation(annotation)
        
    }
    
    func calculateAreaCoverage() -> Double {
        // What this function essentially does is that it calculates the area coverage
        var zeroPin = self.mapView.annotations[0]
        var firstPin = self.mapView.annotations[1]
        var thirdPin = self.mapView.annotations[3]
        
        var zeroPinLocation = CLLocation(latitude: zeroPin.coordinate.latitude, longitude: zeroPin.coordinate.longitude)
        var firstPinLocation = CLLocation(latitude: firstPin.coordinate.latitude, longitude: firstPin.coordinate.longitude)
        var thirdPinLocation = CLLocation(latitude: thirdPin.coordinate.latitude, longitude: thirdPin.coordinate.longitude)
        
        var zeroToFirst = zeroPinLocation.distance(from: firstPinLocation)
        var zeroToThird = zeroPinLocation.distance(from: thirdPinLocation)
        
        var areaCoverage = zeroToFirst * zeroToThird
        return areaCoverage / 1609.344
        
    }
    
    @IBAction func calculateAreaCoverage(_ sender: Any) {
        print(self.calculateAreaCoverage())
    }
    
    @IBAction func clearPins(_ sender: Any) {
        for annotation in self.mapView.annotations {
            self.mapView.removeAnnotation(annotation)
        }
    }
}
