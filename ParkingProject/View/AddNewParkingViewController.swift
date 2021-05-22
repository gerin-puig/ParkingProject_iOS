//
//  AddNewParkingViewController.swift
//  ParkingProject
//
//  Created by Gerin Puig on 2021-05-19.
//

import UIKit
import CoreLocation
import Combine

class AddNewParkingViewController: UIViewController {
    
    @IBOutlet weak var txtBuildingCode: UITextField!
    @IBOutlet weak var txtPlateNumber: UITextField!
    @IBOutlet weak var txtNumberOfHours: UITextField!
    @IBOutlet weak var txtSuitNumberOfHost: UITextField!
    @IBOutlet weak var txtStreetAddress: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var segLocationOption: UISegmentedControl!
    @IBOutlet weak var txtCity: UITextField!
    

    
    private let geocoder = CLGeocoder()
    private let locationController = LocationController()
    private var cancellables : Set<AnyCancellable> = []

    private var longitude : Double = 0.0
    private var latitude : Double = 0.0

    //MARK : controller variables
    let firebaseControllerDb = FirebaseController.getInstance()
    let mageUserDefaults = MaGeUserDefaults()

    
    //MARK : hour selection variables
    let hourOptions = ["1 or less Hour","4 Hour","12 Hours","24 Hours"]
    var pickerview = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationController.initRequests()
        
        //MARK : hours selection
        pickerview.delegate = self
        pickerview.dataSource = self
        txtNumberOfHours.inputView = pickerview
        txtNumberOfHours.textAlignment = .center
        txtNumberOfHours.placeholder = "Select hours to park"
    }
    

    @IBAction func segLocationValChanged(_ sender: UISegmentedControl) {
        switch segLocationOption.selectedSegmentIndex {
            case 1:
                txtCity.text = ""
                txtStreetAddress.text = ""
                txtCountry.isHidden = true
                txtCity.placeholder = "Enter Longitude"
                txtStreetAddress.placeholder = "Enter Latitude"
                
                self.getDeviceLocationAlertBox()
                
            case 0:
                txtCity.text = ""
                txtStreetAddress.text = ""
                txtCity.placeholder = "City"
                txtStreetAddress.placeholder = "Street Address"
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
                  
                    let parkingInfo = Parking(building_code: buildingCode, date: date, geo_location_lat: userCoords.0, geo_location_long: userCoords.1, plate_number: plateNum, number_of_hours: numOfHours, street_address: address, user_id: ss.firebaseControllerDb.getUserIdFromFirebaseAuth())
                    
                    self?.firebaseControllerDb.addParkingToUser(parking: parkingInfo)
                    
                    ss.showAlert(title: "Add Parking", msg: "Parking Added!")
                }
            case 1:
                
                
                guard let latAsString = txtStreetAddress.text, let lat = Double(latAsString) else {
                    return
                }
                guard let lngAsString = txtCity.text, let lng = Double(lngAsString) else {
                    return
                }
                    
                
                let location = CLLocation(latitude: lat, longitude: lng)
              
                self.getReverseAddress(location: location){ userAddress in
                    
                    let address = userAddress
                    print(#function, address)

                    let parkingInfo = Parking(building_code: buildingCode, date: date, geo_location_lat: latAsString,geo_location_long : lngAsString, plate_number: plateNum, number_of_hours: numOfHours, street_address: address, user_id: self.mageUserDefaults.getUserId())
                 
                    
                    self.firebaseControllerDb.addParkingToUser(parking: parkingInfo)

                    self.showAlert(title: "Add Parking", msg: "Parking Added!")
                }
            default:
                break
        }
    }
    
    private func recieveLatVariableChanges(){
        self.locationController.$latVariable
            .receive(on: RunLoop.main)
            .sink{(latVariable) in
            print(#function, "Latitude updates recieved")
//                print(#function,latVariable)
                self.latitude = latVariable ?? 0.0
                print(#function,self.latitude )
                self.txtStreetAddress.text = String(self.latitude)

        }
            .store(in: &cancellables)
    }
    private func recieveLngVariableChanges(){
        self.locationController.$latVariable
            .receive(on: RunLoop.main)
            .sink{(lngVariable) in
            print(#function, "Longitude updates recieved")
                self.longitude = lngVariable ?? 0.0
                print(#function,self.longitude )
                self.txtCity.text = "-"+String(self.longitude)

        }
            .store(in: &cancellables)
    }
    
    // Geo location
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
    
    //Reverse Geo Location
   
    private func getReverseAddress(location : CLLocation, completionBlock: @escaping (_ address: (String) ) -> Void) {
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemark, error in
                completionBlock(self.processReverseGeoResponse(placemarkList: placemark, error: error))
        })
    }

   private func processReverseGeoResponse(placemarkList : [CLPlacemark]?, error : Error?) -> String {
        
        if error != nil{
            print("unable to get location coords","NA","NA")

        }else{
            if let placemarks = placemarkList, let placemark = placemarks.first{
                let city = placemark.locality ?? "NA"
                let street = placemark.thoroughfare ?? "NA"
                print(#function,"------\(city),\(street)")
                return "\(street),\(city)"
//                -79.3798232 43.66981
            }else{
                print("Error while getting location")
            }
        }
    return ("NA")
   }
    
    func getDeviceLocationAlertBox(){
        let alert = UIAlertController(title: "Do you want to get device location?", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(
                    title: "Enter location manually",
                    style: .default,
                    handler: {
                        (UIAlertAction) in
                        
                    }))
        alert.addAction(UIAlertAction(
                    title: "Get current location",
                    style: .default,
                    handler: {
                        (UIAlertAction) in
                        self.recieveLatVariableChanges()
                        self.recieveLngVariableChanges()
                        self.locationController.determineCurrentLocation()

                    }))

                self.present(alert, animated: true, completion: nil)
    }
}

extension AddNewParkingViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hourOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //TODO
        self.txtNumberOfHours.text = hourOptions[row]
        self.txtNumberOfHours.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hourOptions[row]
    }
    
}
