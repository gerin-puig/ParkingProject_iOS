//
//  MapViewController.swift
//  ParkingProject
//
//  Created by Gerin Puig on 2021-05-20.
//
// Gerin Puig - 101343659
// Mayank Arya - 101300566

import Foundation
import MapKit

struct Location {
    var location:String
    var coordinates:CLLocationCoordinate2D
}

class LocationController  : UIViewController{
    let locationManager = CLLocationManager()
   
    @Published var latVariable : Double?
    @Published var lngVariable : Double?
    
    func initRequests() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            print("Location access granted")
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

        }
        else{
            print("Location access denied")
        }
        
    }

    
   
}

extension LocationController :CLLocationManagerDelegate{
  
    
//    -> CLLocationCoordinate2D
func determineCurrentLocation() {
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.requestAlwaysAuthorization()
    
    if CLLocationManager.locationServicesEnabled(){
        print(#function, "Location access granted")
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()

    }else{
        print(#function, "Location access  denied")
    }
}
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //fetch the deivce location\
    
        guard let currentLocation : CLLocationCoordinate2D = manager.location?.coordinate else{
            print(#function,"Error occured")
            return
        }
        
        self.latVariable = currentLocation.latitude
        self.lngVariable = currentLocation.longitude
        print(#function, "lat : \(currentLocation.latitude) , long : \(currentLocation.longitude)")
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function,"Unable to get the location \(error)")
    }
  
}
