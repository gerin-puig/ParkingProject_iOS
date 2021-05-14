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

    func setParkingCell(parkingListArray : parking){
        parkingHeaderLabel.text = parkingListArray.headerLabel
        parkingDetailLabel.text = parkingListArray.detailLabel
    }

}
