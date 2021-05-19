//
//  AddNewParkingViewController.swift
//  ParkingProject
//
//  Created by Gerin Puig on 2021-05-19.
//

import UIKit

class AddNewParkingViewController: UIViewController {
    
    @IBOutlet weak var txtBuildingCode: UITextField!
    @IBOutlet weak var txtPlateNumber: UITextField!
    @IBOutlet weak var txtNumberOfHours: UITextField!
    @IBOutlet weak var txtSuitNumberOfHost: UITextField!
    @IBOutlet weak var txtStreetAddress: UITextField!
    @IBOutlet weak var SliderNumOfHours: UISlider!
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func btnAddParkingPressed(_ sender: UIButton) {
        guard let buildingCode = txtBuildingCode.text, let plateNum = txtPlateNumber.text, let numOfHours = txtNumberOfHours.text, let suitNumber = txtSuitNumberOfHost.text, let address = txtStreetAddress.text else { return }
        
        
    }
    
}
