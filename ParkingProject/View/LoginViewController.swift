//
//  LoginViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-12.
//
// Gerin Puig - 101343659
// Mayank Arya - 

import SwiftUI
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var isRememberMe: UISwitch!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let firebaseController = FirebaseController.getInstance()
    
     let mageUserDefaults = MaGeUserDefaults()
     var newUser:Bool?
     var userData:User?
     var userProfile:Profile?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isRemembered = mageUserDefaults.doRememberMe()
        if isRemembered{
            let email = mageUserDefaults.getLoggedInUser()
            let password = mageUserDefaults.getSavedPassword()
            signUserIn(email: email, password: password)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnLoginPressed(_ sender: UIButton) {
        guard let email = txtUsername.text, let password = txtPassword.text else {
            return
        }
        
        if email.isEmpty || password.isEmpty{
            showAlert(title: "Login", msg: "Email/Password Field Is Empty!")
            return
        }
        
        signUserIn(email: email, password: password)
    }
    
    func signUserIn(email:String, password:String){
        //signs user in
        firebaseController.signInUser(email: email, password: password) {
            [weak self] success in
            guard let ss = self else {return}
            
            if success{
                let parkingListScreen = ss.storyboard?.instantiateViewController(identifier: "TabBarController") as? UITabBarController
                
                ss.show(parkingListScreen!, sender: ss)
                self!.mageUserDefaults.userLogIn(username: email, password: password, isLoggedIn: self!.isRememberMe.isOn)
                self!.mageUserDefaults.setUserId(userId: self!.firebaseController.getUserIdFromFirebaseAuth())
                print(self!.mageUserDefaults.getUserId())
            }
            else
            {
                ss.showAlert(title: "Invalid", msg: "Account Not Found!")
            }
        }
    }
    
    @IBAction func btnSignUpPressed(_ sender: Any) {
        
    }
    
    
    
}
