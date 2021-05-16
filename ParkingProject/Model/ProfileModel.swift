//
//  ProfileModel.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-16.
//

import Foundation

class profile{
    
    var user_id : String
    var first_name : String
    var last_name : String
    var email : String
    var phone_number : String
    var plate_number : String
    
    init(user_id : String,first_name : String, last_name : String, email : String, phone_number : String, plate_number : String){
        self.user_id = user_id
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.phone_number = phone_number
        self.plate_number = plate_number
    }

}
