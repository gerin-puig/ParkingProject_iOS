//
//  LoginViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-12.
//

import SwiftUI

class LoginViewController: UIViewController {
      
    @IBOutlet weak var isRememberMe: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }

}
