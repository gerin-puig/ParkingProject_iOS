//
//  ParkingTableCell.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-14.
//
// Gerin Puig - 101343659
// Mayank Arya - 101300566

import UIKit

class ParkingTableCell: UITableViewCell {

    @IBOutlet weak var parkingHeaderLabel: UILabel!
    @IBOutlet weak var parkingDetailLabel: UILabel!

    func setParkingCell(parkingListData : Parking){
        parkingHeaderLabel.text = parkingListData.plate_number
        parkingDetailLabel.text = parkingListData.building_code + ", " + parkingListData.street_address 
    }

}
