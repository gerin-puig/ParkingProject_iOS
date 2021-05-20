//
//  ParkingDetailsViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-19.
//

import UIKit

class ParkingDetailsViewController: UIViewController {

    var parkingDetail : Parking?
    
    @IBOutlet weak var buildingCodeLabel: UILabel!
    @IBOutlet weak var licensePlateLabel: UILabel!
    @IBOutlet weak var numberOfHoursLabel: UILabel!
    @IBOutlet weak var parkingAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buildingCodeLabel.text = parkingDetail?.building_code
        licensePlateLabel.text = parkingDetail?.plate_number
        numberOfHoursLabel.text = parkingDetail?.number_of_hours
        parkingAddressLabel.text = /*parkingDetail!.apt_number + ", " + */parkingDetail!.street_address
    }
    
}
