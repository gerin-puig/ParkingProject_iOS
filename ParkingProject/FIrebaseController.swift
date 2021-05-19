//
//  FIrebaseController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-16.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseController : ObservableObject{
    
    private let firebaseDb = Firestore.firestore()
    
    @Published private var userId : String?
    @Published var profileData : Profile?
    @Published var parkingDataList : [Parking] = []
    
    var list : [Parking] = []
    
    private static var sharedInstance : FirebaseController?
    
    static func getInstance() -> FirebaseController{
        if sharedInstance != nil{
            return sharedInstance!
        }else{
            sharedInstance = FirebaseController()
            return sharedInstance!
        }
    }
    
    //user login functions
    func getUserIdFromFirebaseAuth() -> String {
        guard let user_id = Auth.auth().currentUser?.uid else{
            return "not found"
        }
        self.userId = user_id
        
        return self.userId!
    }
    
    func signInUser(email:String, password:String, isRememberMe:Bool, myView:UIViewController){
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
            guard let strongSelf = self else { return }
            
            guard error == nil else{
                myView.showAlert(title: "Invalid", msg: "Account Not Found!")
                return
            }
            //print(strongSelf.getUserIdFromFirebaseAuth())
            MaGeUserDefaults().userLogIn(username: email, password: password, isLoggedIn: isRememberMe)
            
            let parkingListScreen = myView.storyboard?.instantiateViewController(identifier: "TabBarController") as? UITabBarController
            
            myView.show(parkingListScreen!, sender: myView)
            
        })
        
    }
    
    //user profile functions
    func signUpUser(email:String,pass:String){
        Auth.auth().createUser(withEmail: email, password: pass, completion: {result, error in
            guard error == nil else{
                return
            }
        })
        
    }
    
    func createProfile(user:User,profile:Profile){
        do{
            try firebaseDb.collection("user").addDocument(from: user)
            try firebaseDb.collection("profile").addDocument(from: profile)
            
        }catch{
            print(error)
        }
    }
    
    func getUserProfile(userId : String){
        firebaseDb.collectionGroup("profile").whereField("user_id", isEqualTo: userId).getDocuments { queryResult, error in
            if let err = error{
                print(#function, "Error Occured \(err)")
            }else{
                if queryResult!.documents.count == 0{
                    print(#function, "No results found")
                }else{
                    for result in queryResult!.documents{
                        do{
                            self.profileData = try result.data(as : Profile.self)
                        }catch{
                            print(#function,"Error while reading data :  \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func saveUserProfile(profile : Profile){
        do{
            try firebaseDb.collection("profile").addDocument(from: profile)
        }
        catch{
            print(#function,error)
        }
    }
    
    func updateUserProfile(profile : Profile, user_id : String){
        do {
            try firebaseDb.collection("profile").document(user_id).setData(from: profile)
            print(#function,"Task updated")
        } catch {
            print(error)
        }
    }
    
    
    
    
    //parking car functions
    func getParkingListData(user_id : String){
        firebaseDb.collectionGroup("parking").whereField("user_id", isEqualTo: user_id).getDocuments { queryResult, error in
            if let err = error{
                print(#function, "Error Occured \(err)")
            }else{
                if queryResult!.documents.count == 0{
                    print(#function, "No results found")
                }else{
                    for result in queryResult!.documents{
                        do{
                            let parkingData = try result.data(as : Parking.self)
                            self.parkingDataList.append(parkingData!)
                        }catch{
                            print(#function,"Error while reading data :  \(error)")
                        }
                    }
                }
            }
        }
    }
    
}
