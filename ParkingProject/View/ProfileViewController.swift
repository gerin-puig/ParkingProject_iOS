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
    private let mageUserDefaults = MaGeUserDefaults()
    
    private var cancellables : Set<AnyCancellable> = []
    
    let firebaseController = FirebaseController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation bar button setup
        let logOutButton = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: #selector(self.logOutUser))
        logOutButton.title = "Log Out >"
        logOutButton.tintColor = .systemYellow
        self.navigationItem.rightBarButtonItem  = logOutButton
        
        self.title = "MaGe"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemYellow, NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 40)]
        
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
      }
    
    override func viewDidAppear(_ animated: Bool) {
        self.firebaseController.getUserProfile(userId: mageUserDefaults.getUserId())
        self.recieveProfileChanges()
    }
    
    @objc func logOutUser(){
        print(#function, "log out pressed")
        mageUserDefaults.userLogOut()

        self.tabBarController?.tabBar.isHidden = true
        guard let loginScreen = storyboard?.instantiateViewController(identifier: "LoginScreen") as? LoginViewController else{
            return
        }
        
        show(loginScreen, sender: (Any).self)
    }
    
    private func recieveProfileChanges(){
        self.firebaseController.$profileData
            .receive(on: RunLoop.main)
            .sink{(profileFirebaseData) in
            print(#function, "Data updates recieved")
                print(profileFirebaseData)
                self.profileData = profileFirebaseData
                self.emailLabel.text = self.profileData?.email_id
                self.firstNameLabel.text = self.profileData?.first_name
                self.lastNameLabel.text = self.profileData?.last_name
                self.plateLabel.text = self.profileData?.plate_number
                self.phoneNumberLabel.text = self.profileData?.phone_number
              
        }
            .store(in: &cancellables)
    }
    

    @IBAction func onEditButtonPressed(_ sender: Any) {
        guard let editProfileVC = storyboard?.instantiateViewController(identifier: "EditProfileScreen") as? EditProfileViewController else{
            return
        }
        
        print(self.profileData)
        editProfileVC.profileData = self.profileData

        show(editProfileVC, sender: (Any).self)
    }
}
