//
//  EditProfileViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-14.
//

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
        
//        self.navigationItem.setHidesBackButton(true, animated: true)

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
    

    @IBAction func saveProfileButton(_ sender: Any) {
        //save button firebase call
        self.profileData?.first_name = firstNameLabel.text ?? ""
        self.profileData?.last_name = lastNameLabel.text ?? ""
        self.profileData?.email_id = emailIdLabel.text ?? ""
        self.profileData?.phone_number = phoneNumberLabel.text ?? ""
        self.profileData?.plate_number = plateNumberLabel.text ?? ""

        firebaseDb.updateUserProfile(profile: self.profileData!, doc_id: (self.profileData?.doc_id)!)
        
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
   
    }
}
