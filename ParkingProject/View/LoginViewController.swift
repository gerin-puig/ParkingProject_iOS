//
//  LoginViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-12.
//

import SwiftUI
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var isRememberMe: UISwitch!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let firebaseController = FirebaseController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoginPressed(_ sender: UIButton) {
        guard let email = txtUsername.text
        else
        {
            showAlert(title: "Email Field", msg: "Email field is Empty!")
            return
        }
        guard let password = txtPassword.text else {
            showAlert(title: "Password Field", msg: "Password field is Empty!")
            return }
        
        //signs user in
        //firebaseController.signInUser(email: email, password: password, isRememberMe: isRememberMe.isOn, myView: self)
        firebaseController.signInUser(email: email, password: password) {
            [weak self] success in
            guard let ss = self else {return}
            
            if success{
                let parkingListScreen = ss.storyboard?.instantiateViewController(identifier: "TabBarController") as? UITabBarController
                
                ss.show(parkingListScreen!, sender: ss)
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

extension UIViewController{
    func showAlert(title:String,msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
