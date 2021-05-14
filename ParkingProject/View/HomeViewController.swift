//
//  HomeViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-12.
//

import SwiftUI



class HomeViewController:  UIViewController {
    var parkingList : [parking] = []
    
    @IBOutlet weak var parkingTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createParkingArray()
        self.parkingTableView.delegate = self
        self.parkingTableView.dataSource = self
        self.parkingTableView.rowHeight = 90
        
    }
    
    func createParkingArray() -> [parking]{
        let parking1 = parking(headerLabel: "Test Parking 1", detailLabel: "Test Parking Detail 1")
        let parking2 = parking(headerLabel: "Test Parking 2", detailLabel: "Test Parking Detail 2")
        
        parkingList.append(parking1)
        parkingList.append(parking2)
        return parkingList
    }
}


extension HomeViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let parkingValue = parkingList[indexPath.row]
        var cell = parkingTableView.dequeueReusableCell(withIdentifier: "parkingCell") as? ParkingTableCell
                
        if (cell == nil) {
        cell = ParkingTableCell(
        style: UITableViewCell.CellStyle.default,
        reuseIdentifier: "parkingCell")
        }
        
        cell?.setParkingCell(parkingListArray: parkingValue)
        
        return cell!
    }
    
}


