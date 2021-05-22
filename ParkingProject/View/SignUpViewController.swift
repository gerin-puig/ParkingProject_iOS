//
//  SignUpViewController.swift
//  ParkingProject
//
//  Created by Gerin Puig on 2021-05-16.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPNum: UITextField!
    @IBOutlet weak var txtPlateNum: UITextField!
    
    let fb = FirebaseController.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    @IBAction func btnSignUpPressed(_ sender: UIButton) {
        guard let email = txtEmail.text, let pass = txtPassword.text,let firstname = txtFirstName.text, let lastname = txtLastName.text, let phone = txtPNum.text, let plate = txtPlateNum.text else {
            return
        }
        
        if !email.isEmpty && !pass.isEmpty && !firstname.isEmpty && !lastname.isEmpty && !phone.isEmpty && !plate.isEmpty
        {
            FirebaseController().signUpUser(email: email, pass: pass)
            showAlert(title: "Sign Up", msg: "Account Created!")
        }
        else{
            showAlert(title: "Sign Up", msg: "Please Fill Out Missing Field!")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){ [self] in
            
            let newUser = User.init(user_id: fb.getUserIdFromFirebaseAuth(), email: email, password: pass)
            let newProfile = Profile(user_id: fb.getUserIdFromFirebaseAuth(), first_name: firstname, last_name: lastname, email_id: email, phone_number: phone, plate_number: plate)
            
            fb.createProfile(user: newUser, profile: newProfile)
            
        }
    }
    
    
}//class end
