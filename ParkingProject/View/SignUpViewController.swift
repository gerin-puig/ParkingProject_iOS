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
        
    }
    
    @IBAction func btnSignUpPressed(_ sender: UIButton) {
        if let email = txtEmail.text, let pass = txtPassword.text
        {
            if !email.isEmpty && !pass.isEmpty
            {
                FirebaseController().signUpUser(email: email, pass: pass)
                showAlert(title: "Sign Up", msg: "Account Created!")
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){ [self] in
            
            if let email = txtEmail.text, let pass = txtPassword.text, let firstname = txtFirstName.text, let lastname = txtLastName.text, let phone = txtPNum.text, let plate = txtPlateNum.text{
                
                let newUser = User.init(user_id: fb.getUserIdFromFirebaseAuth(), email: email, password: pass)
                let newProfile = Profile(user_id: fb.getUserIdFromFirebaseAuth(), first_name: firstname, last_name: lastname, email_id: email, phone_number: phone, plate_number: plate)
                
                fb.createProfile(user: newUser, profile: newProfile)
                
            }
            
        }
    }
        @IBAction func btnReturnPressed(_ sender: Any) {
            //        let LoginScreen = self.storyboard?.instantiateViewController(identifier: "LoginScreen") as? LoginViewController
            //
            //        if isCreated{
            //            if let email = txtEmail.text, let pass = txtPassword.text, let firstname = txtFirstName.text, let lastname = txtLastName.text, let phone = txtPNum.text, let plate = txtPlateNum.text{
            //
            //                let newUser = User.init(user_id: "", email: email, password: pass)
            //                let newProfile = Profile(user_id: "", first_name: firstname, last_name: lastname, email_id: email, phone_number: phone, plate_number: plate)
            //
            //                LoginScreen?.newUser = true
            //                LoginScreen?.userData = newUser
            //                LoginScreen?.userProfile = newProfile
            //
            //            }
            //        }
            //
            //        self.show(LoginScreen!, sender: self)
            
        }
        
        
    }//class end
