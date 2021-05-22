//
//  ParkingDetailsViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-19.
//

import UIKit
import MapKit

class ParkingDetailsViewController: UIViewController, UIGestureRecognizerDelegate {

    var parkingDetail : Parking?
    let locationManager = CLLocationManager()

    
    @IBOutlet weak var buildingCodeLabel: UILabel!
    @IBOutlet weak var licensePlateLabel: UILabel!
    @IBOutlet weak var numberOfHoursLabel: UILabel!
    @IBOutlet weak var parkingAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var currentLat : Double?
    var currentLng : Double?
    
    var parkingLat : Double?
    var parkingLng : Double?

  
    override func viewDidLoad() {
        super.viewDidLoad()


    
        
        //Mark : Set Label for data
        buildingCodeLabel.text = parkingDetail?.building_code
        licensePlateLabel.text = parkingDetail?.plate_number
        numberOfHoursLabel.text = parkingDetail?.number_of_hours
        parkingAddressLabel.text = /*parkingDetail!.apt_number + ", " + */parkingDetail!.street_address
        
        //MARK : setup map lat lng
        guard let latAsString = parkingDetail?.geo_location_lat , let lat = Double(latAsString) else {
            return
        }
        
        guard let lngAsString = parkingDetail?.geo_location_long, let lng = Double(lngAsString) else {
            return
        }
        
        self.parkingLat = lat
        self.parkingLng = lng
        let parkingLocation = CLLocationCoordinate2D(latitude: self.parkingLat ?? 0.0, longitude: self.parkingLng ?? 0.0)
        
        self.displayLocationOnMap(location: parkingLocation)

        let onMapTap = UITapGestureRecognizer(target: self, action: #selector(onMapClick))
          mapView.addGestureRecognizer(onMapTap)
        
        
        if CLLocationManager.locationServicesEnabled(){
            print(#function, "Location access granted")
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.startUpdatingLocation()
        }else{
            print(#function, "Location access  denied")
        }
        
     
    }
    
    @objc func onMapClick(){
        self.openInMapsAlertBox()
    }
  
   
    func openInMapsAlertBox(){
        let alert = UIAlertController(title: "Do you want to navigate to location using Maps?", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(
                    title: "Go Back",
                    style: .default,
                    handler: nil))
                        
        alert.addAction(UIAlertAction(
                    title: "Yes",
                    style: .default,
                    handler: {
                        (UIAlertAction) in
                        let parkingLocation = CLLocationCoordinate2D(latitude: self.parkingLat ?? 0.0, longitude: self.parkingLng ?? 0.0)
                        
                        self.openLocationInMapApp(destinationLocation: parkingLocation)

                    }))

                self.present(alert, animated: true, completion: nil)
    }
    
}

extension ParkingDetailsViewController : CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //fetch the deivce location
    
        guard let currentLocation : CLLocationCoordinate2D = manager.location?.coordinate else{
            print(#function,"Error occured")
            return
        }
        
        self.currentLat = currentLocation.latitude
        self.currentLng = currentLocation.longitude
        print(#function, "lat : \(currentLocation.latitude) , long : \(currentLocation.longitude)")
        
    }
    
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
    
    func openLocationInMapApp(destinationLocation : CLLocationCoordinate2D){
        let currentLocLat = self.currentLat ?? 0.0
        let currentLocLng = self.currentLng ?? 0.0
       

        guard let latAsString = parkingDetail?.geo_location_lat, let destinationLat = Double(latAsString) else {
            return
        }
        guard let lngAsString = parkingDetail?.geo_location_long, let destinationLng = Double(lngAsString) else {
            return
        }
        
        let currentLocation = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocLat, longitude: currentLocLng)))
        currentLocation.name = "Current Position"
        
        let destinationLocation = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)))
        destinationLocation.name = "Parking Location"
        
        MKMapItem.openMaps(with: [currentLocation, destinationLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
}
