//
//  HomeViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-12.
//

import SwiftUI
import FirebaseFirestore
import Combine


class HomeViewController:  UIViewController {
  
    var parkingList : [Parking] = []
    @IBOutlet weak var parkingTableView: UITableView!
    let firebaseDb = FirebaseController.getInstance()
    private var cancellables : Set<AnyCancellable> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false

        self.firebaseDb.getParkingListData(user_id: "0")
        self.recieveParkingListChanges()
        
        self.parkingTableView.delegate = self
        self.parkingTableView.dataSource = self
        self.parkingTableView.rowHeight = 90
        
    }
    
    private func recieveParkingListChanges(){
        self.firebaseDb.$parkingDataList
            .receive(on: RunLoop.main)
            .sink{(listOfParking) in
            print(#function, "Data updates recieved")
                self.parkingList.removeAll()
                self.parkingList.append(contentsOf: listOfParking)
                self.parkingTableView.reloadData()
        }
            .store(in: &cancellables)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let parkingDetailsVC = storyboard?.instantiateViewController(identifier: "ParkingDetailScreen") as? ParkingDetailsViewController else{
            return
        }
        
        parkingDetailsVC.parkingDetail = parkingList[indexPath.row]
            print(parkingList[indexPath.row])
        
        show(parkingDetailsVC, sender: (Any).self)
    }
    
    
}


