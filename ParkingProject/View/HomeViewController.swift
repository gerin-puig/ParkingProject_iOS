//
//  HomeViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-12.
//

import SwiftUI

class HomeViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    @IBOutlet weak var parkingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parkingTableView.delegate = self
        self.parkingTableView.dataSource = self
        self.parkingTableView.rowHeight = 110
    }
}


