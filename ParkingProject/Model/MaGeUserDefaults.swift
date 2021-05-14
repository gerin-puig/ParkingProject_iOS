//
//  MaGeUserDefaults.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-12.
//

import Foundation

class MaGeUserDefaults{
    private let mageDefaults = UserDefaults.standard
    private let keyUsername = "Username"
    private let keyPassword = "Password"
    private let keyRememberMe = "RememberMe"
    
    func userLogIn(username : String, password : String, isLoggedIn : Bool){
        mageDefaults.setValue(username, forKey: keyUsername)
        mageDefaults.setValue(password, forKey: keyPassword)
        mageDefaults.setValue(isLoggedIn ,forKey: keyRememberMe)
    }
    
    func userLogOut(){
        mageDefaults.removeObject(forKey: keyRememberMe)
        mageDefaults.removeObject(forKey: keyUsername)
        mageDefaults.removeObject(forKey: keyPassword)
    }
    
    func getLoggedInUser() -> String{
        return mageDefaults.string(forKey: keyUsername)!
    }
    
    func doRememberMe() -> Bool{
        return mageDefaults.bool(forKey: keyRememberMe)
    }
    

}
