//
//  MaGeUserDefaults.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-12.
//
// Gerin Puig - 101343659
// Mayank Arya - 101300566

import Foundation

class MaGeUserDefaults{
    private let mageDefaults = UserDefaults.standard
    private let keyUsername = "Username"
    private let keyPassword = "Password"
    private let keyRememberMe = "RememberMe"
    private let keyUserId = "UserId"
    
    
    func getUserId() -> String{
        return mageDefaults.string(forKey: self.keyUserId)!
    }
    
    func setUserId(userId : String){
        mageDefaults.setValue(userId, forKey: keyUserId)
    }
    
    
    func userLogIn(username : String, password : String, isLoggedIn : Bool){
        mageDefaults.setValue(username, forKey: keyUsername)
        mageDefaults.setValue(password, forKey: keyPassword)
        mageDefaults.setValue(isLoggedIn ,forKey: keyRememberMe)
    }
    
    func userLogOut(){
        mageDefaults.removeObject(forKey: keyRememberMe)
        mageDefaults.removeObject(forKey: keyUsername)
        mageDefaults.removeObject(forKey: keyPassword)
        mageDefaults.removeObject(forKey: keyUserId)
    }
    
    func getLoggedInUser() -> String{
        return mageDefaults.string(forKey: keyUsername)!
    }
    
    func getSavedPassword() -> String{
        return mageDefaults.string(forKey: keyPassword)!
    }
    
    func doRememberMe() -> Bool{
        return mageDefaults.bool(forKey: keyRememberMe)
    }
    
    
    

}
