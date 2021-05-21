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

    func setParkingCell(parkingListData : Parking){
        parkingHeaderLabel.text = parkingListData.plate_number
        parkingDetailLabel.text = parkingListData.building_code + ", " + parkingListData.street_address 
    }

}
