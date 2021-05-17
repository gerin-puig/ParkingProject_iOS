//
//  FIrebaseController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-16.
//

import Foundation
import FirebaseFirestore

class FirebaseController{
    
    private let firebaseDb = Firestore.firestore()
    
    //user login functions
    
    //user profile functions
    func signUpUserProfile(profile : Profile){
     
    }
    
    func getUserProfile(userId : String) {
        var profileData : Profile?
        
        firebaseDb.collectionGroup("profile").whereField("user_id", isEqualTo: userId).getDocuments { queryResult, error in
            if let err = error{
                print(#function, "Error Occured \(err)")
            }else{
                if queryResult!.documents.count == 0{
                    print(#function, "No results found")
                }else{
                    for result in queryResult!.documents{
                        do{
                            profileData = try result.data(as : Profile.self)
                            print(profileData!)
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
    func getUserParkingList(userId : String) -> [Parking]{
        var parkingList : [Parking] = []
        firebaseDb.collectionGroup("parking").whereField("user_id", isEqualTo: userId).getDocuments { queryResult, error in
            if let err = error{
                print(#function, "Error Occured \(err)")
            }else{
                if queryResult!.documents.count == 0{
                    print(#function, "No results found")
                }else{
                    for result in queryResult!.documents{
                        do{
                            let parkingData = try result.data(as : Parking.self)
                            parkingList.append(parkingData!)
                        }catch{
                            print(#function,"Error while reading data :  \(error)")
                        }
                    }
                }
            }
        }
        return parkingList
    }
}
