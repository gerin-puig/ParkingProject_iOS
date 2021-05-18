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
        
        //will move just testing
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else{
                strongSelf.showAlert(title: "Invalid", msg: "Account not found!")
                return
            }
            
            MaGeUserDefaults().userLogIn(username: email, password: password, isLoggedIn: strongSelf.isRememberMe.isOn)
            
            let parkingListScreen = strongSelf.storyboard?.instantiateViewController(identifier: "TabBarController") as? UITabBarController
            strongSelf.show(parkingListScreen!, sender: self)
            
        })
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
