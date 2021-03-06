//
//  FIrebaseController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-16.
//
// Gerin Puig - 101343659
// Mayank Arya - 101300566

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseController : ObservableObject{
    
    private let firebaseDb = Firestore.firestore()
    private var MageUserDefaults = MaGeUserDefaults()
    @Published private var userId : String?
    @Published var profileData : Profile?
    @Published var parkingDataList : [Parking] = []
    var list : [Parking] = []
    private static var sharedInstance : FirebaseController?
    var profileDocId : String?
    var userDocId : String?
    
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

    
    func signInUser(email:String, password:String, completionBlock: @escaping (_ success:Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
            guard let strongSelf = self else { return }
            
            if let user = result?.user {
                self?.MageUserDefaults.setUserId(userId: user.uid)
                print("Saved User Id in user Defaults")
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        })
    }
    

    //user profile functions
    func signUpUser(email:String,pass:String, completionBlock: @escaping(_ success:Bool) -> Void){
        

        Auth.auth().createUser(withEmail: email, password: pass, completion: {result, error in

            if let err = error{
                let er = err as NSError
                switch er.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        completionBlock(false)
                        break
                    case AuthErrorCode.invalidEmail.rawValue:
                        completionBlock(false)
                        break
                    default:
                        return
                }
                return
            }

            if let user = result?.user{
                print(user)
                completionBlock(true)
            }
            else{
                completionBlock(false)
            }

        })
        
    }

    
    //user profile functions
    
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
                            self.profileDocId = self.profileData?.doc_id
                        }catch{
                            print(#function,"Error while reading data :  \(error)")
                        }
                    }
                }
            }
        }
    }
    
    
    func updateUserProfile(profile : Profile, doc_id : String){
        do {
            try firebaseDb.collection("profile").document(doc_id).setData(from: profile)
            print(#function,"Task Updated.")
                
        } catch {
            print(error)
        }
    }
    
    func deleteUserProfile(){
        do {

            let user = Auth.auth().currentUser

            user?.delete { error in
              if let error = error {
                print(#function,"Error occured while deleting user from firebase A \(error)")
              } else {
                print(#function,"Account deleted successfully")
              }
            }
        } catch {
            print(#function,error)
        }
    }
    
    
    //parking car functions
    func getParkingListData(user_id : String){
        firebaseDb.collectionGroup("parking").order(by: "date", descending: true).whereField("user_id", isEqualTo: user_id).getDocuments { queryResult, error in
            if let err = error{
                print(#function, "Error Occured \(err)")
            }else{
                if queryResult!.documents.count == 0{
                    print(#function, "No results found")
                    self.parkingDataList = []
                }else{
                    self.parkingDataList.removeAll()
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
    
    func addParkingToUser(parking:Parking){
        do {
            try firebaseDb.collection("parking").addDocument(from: parking)
            print(#function,"Parking added")
        } catch {
            print(error)
        }
    }

    
    func deleteParking(parking_doc_id : String){
        try firebaseDb.collection("parking").document(parking_doc_id).delete()
    }
}
