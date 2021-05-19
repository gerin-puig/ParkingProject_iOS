//
//  ProfileViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-14.
//

import UIKit
import FirebaseFirestore
import Combine

class ProfileViewController: UIViewController {

    var profileData : Profile?
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var plateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    private var cancellables : Set<AnyCancellable> = []
    
    let firebaseController = FirebaseController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseController.getUserProfile(userId: "0")
//        setProfileData()
        recieveChanges()
  
        // Do any additional setup after loading the view.
    }
    
    private func recieveChanges(){
        self.firebaseController.$profileData
            .receive(on: RunLoop.main)
            .sink{(listofLaunches) in
            print(#function, "Data updates recieved")
                self.profileData = listofLaunches
                self.emailLabel.text = self.profileData?.email_id
                self.firstNameLabel.text = self.profileData?.first_name
                self.lastNameLabel.text = self.profileData?.last_name
                self.plateLabel.text = self.profileData?.plate_number
                self.phoneNumberLabel.text = self.profileData?.phone_number
              
        }
            .store(in: &cancellables)
    }
    

}
