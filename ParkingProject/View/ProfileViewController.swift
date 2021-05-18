//
//  ProfileViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-14.
//

import UIKit
import FirebaseFirestore

class ProfileViewController: UIViewController {

    var profileData : Profile?
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var plateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let firebaseController = FirebaseController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      setProfileData()
    }
    func setProfileData() {
        firebaseController.getInstance().collectionGroup("profile").whereField("user_id", isEqualTo: "0").getDocuments { queryResult, error in
            if let err = error{
                print(#function, "Error Occured \(err)")
            }else{
                if queryResult!.documents.count == 0{
                    print(#function, "No results found")
                }else{
                    for result in queryResult!.documents{
                        do{
                            self.profileData = try result.data(as : Profile.self)
                            print(#function,self.profileData!)
                            self.emailLabel.text = self.profileData?.email_id
                            self.firstNameLabel.text = self.profileData?.first_name
                            self.lastNameLabel.text = self.profileData?.last_name
                            self.plateLabel.text = self.profileData?.plate_number
                            self.phoneNumberLabel.text = self.profileData?.phone_number
                          
                        }catch{
                            print(#function,"Error while reading data :  \(error)")
                        }
                    }
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
