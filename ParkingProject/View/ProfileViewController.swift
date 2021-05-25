//
//  ProfileViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-14.
//
// Gerin Puig - 101343659
// Mayank Arya - 101300566

import UIKit
import FirebaseFirestore
import Combine

class ProfileViewController: UIViewController {

    var profileData : Profile?
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var plateLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
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
    
    
    @IBAction func OnProfileDeleteButtonPressed(_ sender: Any) {
        self.onDeleteProfileAlertBox()
    }
    
    
    func onDeleteProfileAlertBox(){
        let alert = UIAlertController(title: "Are you sure you want to delete your account?", message: "All the parking data will be lost if you delete the account.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(
                    title: "Go Back",
                    style: .default,
                    handler:nil))
        alert.addAction(UIAlertAction(
                    title: "Delete Account",
                    style: .default,
                    handler: {
                        (UIAlertAction) in
                        self.askForCredentialsAgain()

                    }))

                self.present(alert, animated: true, completion: nil)
    }
    
    func askForCredentialsAgain(){
        let alert = UIAlertController(title: "Please confirm account deletion by adding your password!", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter password"
        }
        alert.addAction(UIAlertAction(
                    title: "Go Back",
                    style: .default,
                    handler:nil))
        alert.addAction(UIAlertAction(
                    title: "Ok",
                    style: .default,
                    handler: {
                        (UIAlertAction) in
                        let userPassword = alert.textFields![0].text
                        let userName = self.mageUserDefaults.getLoggedInUser()
                        

                        self.firebaseController.signInUser(email: userName, password: userPassword!) {
                            [weak self] success in
                            guard let ss = self else {return}
                            
                            if success{
                                ss.firebaseController.deleteUserProfile()
                                ss.logOutUser()
                            }
                            else
                            {
                                ss.showAlert(title: "Invalid", msg: "Account Not Found!")
                            }
                        }

                    }))

                self.present(alert, animated: true, completion: nil)
    }
}
