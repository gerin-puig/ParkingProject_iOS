//
//  ProfileModel.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-16.
//
// Gerin Puig - 101343659
// Mayank Arya - 101300566

import Foundation
import FirebaseFirestoreSwift

struct Profile : Codable{
    @DocumentID  var doc_id : String?
    var user_id : String
    var first_name : String
    var last_name : String
    var email_id : String
    var phone_number : String
    var plate_number : String
    
}
