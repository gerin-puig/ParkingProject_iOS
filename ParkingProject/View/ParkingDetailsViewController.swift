//
//  ParkingDetailsViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-19.
//

import UIKit
import MapKit

class ParkingDetailsViewController: UIViewController {

    var parkingDetail : Parking?
    let locationManager = CLLocationManager()

    
    @IBOutlet weak var buildingCodeLabel: UILabel!
    @IBOutlet weak var licensePlateLabel: UILabel!
    @IBOutlet weak var numberOfHoursLabel: UILabel!
    @IBOutlet weak var parkingAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buildingCodeLabel.text = parkingDetail?.building_code
        licensePlateLabel.text = parkingDetail?.plate_number
        numberOfHoursLabel.text = parkingDetail?.number_of_hours
        parkingAddressLabel.text = /*parkingDetail!.apt_number + ", " + */parkingDetail!.street_address
        guard let latAsString = parkingDetail?.geo_location_lat , let lat = Double(latAsString) else {
            return
        }
        guard let lngAsString = parkingDetail?.geo_location_long, let lng = Double(lngAsString) else {
            return
        }
//        var parkingLocation = CLLocation(latitude: lat, longitude: lng)
      
        var parkingLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.displayLocationOnMap(location: parkingLocation)

//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.requestAlwaysAuthorization()
//
        
        if CLLocationManager.locationServicesEnabled(){
            print(#function, "Location access granted")
            
//            self.locationManager.delegate = self
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//            self.locationManager.startUpdatingLocation()
        }else{
            print(#function, "Location access  denied")
        }
    }
    
}

extension ParkingDetailsViewController : CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //fetch the deivce location\
//
//        guard let currentLocation : CLLocationCoordinate2D = manager.location?.coordinate else{
//            return
//        }
//
//        print(#function, "lat : \(currentLocation.latitude) , long : \(currentLocation.longitude)")
//
//        self.displayLocationOnMap(location: currentLocation)
//    }
    
    
 
    func displayLocationOnMap(location : CLLocationCoordinate2D){
        //zoom
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        //centre the map on
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView?.setRegion(region, animated: true)
        
        //display annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "You are here!"
        self.mapView.addAnnotation(annotation)
    }
}
