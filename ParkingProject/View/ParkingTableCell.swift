//
//  ParkingTableCell.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-14.
//

import UIKit

class ParkingTableCell: UITableViewCell {

    @IBOutlet weak var parkingHeaderLabel: UILabel!
    @IBOutlet weak var parkingDetailLabel: UILabel!

    func setParkingCell(parkingListArray : Parking){
        parkingHeaderLabel.text = parkingListArray.plate_number
        parkingDetailLabel.text =  parkingListArray.apt_number + ", " +  parkingListArray.street_address
    }

}
