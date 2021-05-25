//
//  HomeViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-12.
//
// Gerin Puig - 101343659
// Mayank Arya - 101300566

import SwiftUI
import FirebaseFirestore
import Combine


class HomeViewController:  UIViewController {
  
    var parkingList : [Parking] = []
    @IBOutlet weak var parkingTableView: UITableView!
    let firebaseDb = FirebaseController.getInstance()
    private var cancellables : Set<AnyCancellable> = []

    private let mageUserDefaults = MaGeUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false

        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemYellow, NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 40)]
        
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
                

        //MARK : Parking table source
        self.parkingTableView.delegate = self
        self.parkingTableView.dataSource = self
        self.parkingTableView.rowHeight = 90
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.firebaseDb.getParkingListData(user_id: mageUserDefaults.getUserId())
        self.recieveParkingListChanges()
    }
    
    private func recieveParkingListChanges(){
        self.firebaseDb.$parkingDataList
            .receive(on: RunLoop.main)
            .sink{(listOfParking) in
            print(#function, "Parking data updates recieved")
                self.parkingTableView.reloadData()
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

        cell?.setParkingCell(parkingListData : parkingValue)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let parkingDetailsVC = storyboard?.instantiateViewController(identifier: "ParkingDetailScreen") as? ParkingDetailsViewController else{
            return
        }
        print(#function, parkingList[indexPath.row].doc_id)
        
        parkingDetailsVC.parkingDetail = parkingList[indexPath.row]
            print(parkingList[indexPath.row])
        
        show(parkingDetailsVC, sender: (Any).self)
    }
    
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if ( editingStyle == UITableViewCell.EditingStyle.delete && indexPath.row < self.parkingList.count){
            let parking_id = self.parkingList[indexPath.row].doc_id
            if(parking_id == nil){
                showAlert(title: "Error", msg: "Error occured while deleting.")
            }else{
                  self.firebaseDb.deleteParking(parking_doc_id: parking_id!)

                self.firebaseDb.getParkingListData(user_id: mageUserDefaults.getUserId())
                self.recieveParkingListChanges()
                print("Executed")
                
                //MARK : update list
              
            }
        }
    }

}


