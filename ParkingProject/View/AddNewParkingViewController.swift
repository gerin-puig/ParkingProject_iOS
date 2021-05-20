//
//  AddNewParkingViewController.swift
//  ParkingProject
//
//  Created by Gerin Puig on 2021-05-19.
//

import UIKit
import CoreLocation

class AddNewParkingViewController: UIViewController {
    
    @IBOutlet weak var txtBuildingCode: UITextField!
    @IBOutlet weak var txtPlateNumber: UITextField!
    @IBOutlet weak var txtNumberOfHours: UITextField!
    @IBOutlet weak var txtSuitNumberOfHost: UITextField!
    @IBOutlet weak var txtStreetAddress: UITextField!
    @IBOutlet weak var SliderNumOfHours: UISlider!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var segLocationOption: UISegmentedControl!
    @IBOutlet weak var txtCity: UITextField!
    
    private let geocoder = CLGeocoder()
    let fb = FirebaseController.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        LocationController().initRequests()

        txtNumberOfHours.text = String(SliderNumOfHours.value)
        
//        SliderNumOfHours.value = Float(txtNumberOfHours.text!) ?? 0
    }
    
    @IBAction func NumHoursValueChanged(_ sender: UITextField) {
        SliderNumOfHours.value = Float(sender.text!) ?? 0
        
    }
    
    @IBAction func txtValueChanged(_ sender: UITextField) {
        SliderNumOfHours.value = Float(sender.text!) ?? 0
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentVal = Int(sender.value)
        txtNumberOfHours.text = String(currentVal)
        
    }
    @IBAction func segLocationValChanged(_ sender: UISegmentedControl) {
        switch segLocationOption.selectedSegmentIndex {
            case 1:
                txtCountry.isHidden = true
                txtStreetAddress.isHidden = true
                txtCity.isHidden = true
            case 0:
                txtCountry.isHidden = false
                txtStreetAddress.isHidden = false
                txtCity.isHidden = false
            default:
                break
        }
    }
    
    @IBAction func btnAddParkingPressed(_ sender: UIButton) {
        guard let buildingCode = txtBuildingCode.text, let plateNum = txtPlateNumber.text, let numOfHours = txtNumberOfHours.text, let suitNumber = txtSuitNumberOfHost.text, let address = txtStreetAddress.text, let country = txtCountry.text, let city = txtCity.text else { return }
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        let date = formatter.string(from: today)
        
        switch segLocationOption.selectedSegmentIndex {
            case 0:
                let postalAddress = "\(country), \(city), \(address)"
                
                self.getLocation(address: postalAddress){
                    [weak self] userCoords in
                    guard let ss = self else {return}
                    
                    //print(userCoords)
                    let loc = "\(userCoords.0),\(userCoords.1)"
                    let parkingInfo = Parking(building_code: buildingCode, date: date, geo_location: loc, plate_number: plateNum, number_of_hours: numOfHours, street_address: address, user_id: ss.fb.getUserIdFromFirebaseAuth())
                    
                    ss.fb.addParkingToUser(parking: parkingInfo)
                    
                    ss.showAlert(title: "Add Parking", msg: "Parking Added!")
                }
            case 1:
                
                break
            default:
                break
        }
    }
    
    private func getLocation(address : String, completionBlock: @escaping (_ coords:(String,String)) -> Void){
        geocoder.geocodeAddressString(address, completionHandler: {
            placemark, error in
            completionBlock(self.processGeoResponse(placemarks: placemark, error: error))
        })
    }
    
    private func processGeoResponse(placemarks:[CLPlacemark]?, error: Error?) -> (String,String){
        if error != nil{
            return ("unable to get location coords","not found")
        }
        else{
            var obtainedLocation:CLLocation?
            
            if let placemark = placemarks, placemarks!.count > 0{
                obtainedLocation = placemark.first?.location
            }
            
            if obtainedLocation != nil {
                return (String(obtainedLocation!.coordinate.latitude), String(obtainedLocation!.coordinate.longitude))
            }
            else{
                //print("no coords found :(")
                return ("not found","not found")
            }
        }
    }
    
}
