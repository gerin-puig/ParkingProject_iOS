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
    func getUserIdFromFirebaseAuth(){
        guard let user_id = Auth.auth().currentUser?.uid else{
            return
        }
        self.userId = user_id
    }
    
    
    //user profile functions
    func signUpUserProfile(profile : Profile){
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
