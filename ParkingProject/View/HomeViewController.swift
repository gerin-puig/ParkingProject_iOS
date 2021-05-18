//
//  HomeViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-12.
//

import SwiftUI
import FirebaseFirestore



class HomeViewController:  UIViewController {
  
    var parkingList : [Parking] = []
    
    
    @IBOutlet weak var parkingTableView: UITableView!
    let firebaseDb = FirebaseController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parkingTableView.delegate = self
        self.parkingTableView.dataSource = self
        self.parkingTableView.rowHeight = 90
        
    }
    
    func getParkingListData(user_id : String){
        firebaseDb.getInstance().collectionGroup("parking").whereField("user_id", isEqualTo: user_id).getDocuments { queryResult, error in
            if let err = error{
                print(#function, "Error Occured \(err)")
            }else{
                if queryResult!.documents.count == 0{
                    print(#function, "No results found")
                }else{
                    for result in queryResult!.documents{
                        do{
                            let parkingData = try result.data(as : Parking.self)
                            self.parkingList.append(parkingData!)
                        }catch{
                            print(#function,"Error while reading data :  \(error)")
                        }
                    }
                    self.parkingTableView.reloadData()
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        getParkingListData(user_id: "0")

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


