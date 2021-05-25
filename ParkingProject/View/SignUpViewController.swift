//
//  SignUpViewController.swift
//  ParkingProject
//
//  Created by Gerin Puig on 2021-05-16.
//
// Gerin Puig - 101343659
// Mayank Arya - 101300566

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
        
        self.title = "MaGe"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemYellow, NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 40)]
        
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    @IBAction func btnSignUpPressed(_ sender: UIButton) {
        guard let email = txtEmail.text, let pass = txtPassword.text,let firstname = txtFirstName.text, let lastname = txtLastName.text, let phone = txtPNum.text, let plate = txtPlateNum.text else {
            return
        }
        
        if !email.isEmpty && !pass.isEmpty && !firstname.isEmpty && !lastname.isEmpty && !phone.isEmpty && !plate.isEmpty
        {

            
            FirebaseController().signUpUser(email: email, pass: pass){
                [weak self] success in
                guard let ss = self else {return}
                if success{
                    
                    //wait a few seconds for the auth to update and create the newly created user
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){ [self] in
                        
                        let newUser = User.init(user_id: ss.fb.getUserIdFromFirebaseAuth(), email: email, password: pass)
                        let newProfile = Profile(user_id: ss.fb.getUserIdFromFirebaseAuth(), first_name: firstname, last_name: lastname, email_id: email, phone_number: phone, plate_number: plate)
                        
                        ss.fb.createProfile(user: newUser, profile: newProfile)
                        
                    }
                    
                    ss.showAlert(title: "Sign Up", msg: "Account Created!")
                    
                    ss.txtEmail.text = ""
                    ss.txtPassword.text = ""
                    ss.txtFirstName.text = ""
                    ss.txtLastName.text = ""
                    ss.txtPNum.text = ""
                    ss.txtPlateNum.text = ""
                }
                else{
                    ss.showAlert(title: "Sign Up", msg: "Email Invalid!")
                }
            }
            
        }
        else{
            showAlert(title: "Sign Up", msg: "Please Fill Out Missing Field!")
        }
        
        
    }
    
}//class end
