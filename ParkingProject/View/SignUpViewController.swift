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
    
    let db = Firestore.firestore()
    
    var myid:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //print(self.myid.count)
        
    }
    
    @IBAction func btnSignUpPressed(_ sender: UIButton) {
        if let email = txtEmail.text, let pass = txtPassword.text{
            if !email.isEmpty && !pass.isEmpty{
                Auth.auth().createUser(withEmail: email, password: pass, completion: {result, error in
                   
                    guard error == nil else{
                        let alert = UIAlertController(title: "Sign Up", message: "Account Creation Failed!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                        return
                    }
                })
            }
            
            let newUser = User.init(id: nil, email: email, password: pass)
           do{
                //try db.collection("user").addDocument(from: newUser)

            db.collection("user").whereField("email", isEqualTo: email).getDocuments
            {
                (queryResults, error) in
                
                if let err = error{
                    print("Error \(err)")
                    return
                }
                else
                {
                    if queryResults!.documents.count == 0
                    {
                        print("No results found")
                    }
                    else
                    {
                        for result in queryResults!.documents
                        {
                            //print(result.data())
                            //print("this id: " + result.documentID)
                            do
                            {
                                let myUser = try result.data(as: User.self)
                                self.myid.append(myUser!)
                            }
                            catch
                            {
                                print(error)
                            }
                        }
                        //print("num: \(self.myid.count)")
                        //print(self.myid[0].id!)
                    }
                }
            }
            
                //let newProfile = Profile(id: self.myid[0].id!, email: email, password: pass, firstName: self.txtFirstName.text!, lastName: self.txtLastName.text!, phoneNum: self.txtPNum.text!, plateNum: self.txtPlateNum.text!)
            
                //try Firestore.firestore().collection("profile").addDocument(from: newProfile)
                
            }catch{
                print(error)
            }
            showAlert(title: "Sign Up", msg: "Account Created!")
            print("Account Made")
            
        }
        
        
    }
    
    
}//class end
