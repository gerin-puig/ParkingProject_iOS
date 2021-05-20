//
//  MapViewController.swift
//  ParkingProject
//
//  Created by Gerin Puig on 2021-05-20.
//

import Foundation
import MapKit

struct Location {
    var location:String
    var coordinates:CLLocationCoordinate2D
}

class LocationController{
    let locationManager = CLLocationManager()
    
    func initRequests() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            print("Location access granted")
            
            //locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        else{
            print("Location access denied")
        }
        
    }
}


