//
//  EditProfileViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-14.
//
// Gerin Puig - 101343659
// Mayank Arya - 

import UIKit

class EditProfileViewController: UIViewController {

    var profileData : Profile?
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var emailIdLabel: UITextField!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var plateNumberLabel: UITextField!
    
    let firebaseDb = FirebaseController.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MaGe"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemYellow, NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 40)]
        
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let backbutton = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: #selector(self.backAction))
        backbutton.title = "< Back"
        backbutton.tintColor = .systemYellow
        self.navigationItem.leftBarButtonItem  = backbutton
        

        
        if(self.profileData !=  nil){
            self.setProfileData(profileData: self.profileData! )
        }
        else{
            //request profile data from firebase
        }
        
    }
    

    func setProfileData(profileData : Profile){
        self.firstNameLabel.text = profileData.first_name
        self.lastNameLabel.text = profileData.last_name
        self.emailIdLabel.text = profileData.email_id
        self.phoneNumberLabel.text = profileData.phone_number
        self.plateNumberLabel.text = profileData.plate_number
    }
    
    @objc func backAction(){
        print("back clicked")
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func saveProfileButton(_ sender: Any) {
        //save button firebase call
        self.profileData?.first_name = firstNameLabel.text ?? ""
        self.profileData?.last_name = lastNameLabel.text ?? ""
        self.profileData?.email_id = emailIdLabel.text ?? ""
        self.profileData?.phone_number = phoneNumberLabel.text ?? ""
        self.profileData?.plate_number = plateNumberLabel.text ?? ""

        firebaseDb.updateUserProfile(profile: self.profileData!, doc_id: (self.profileData?.doc_id)!)
        
        navigationController?.popViewController(animated: false)
        self.dismiss(animated: true, completion: nil)
   
    }
}
