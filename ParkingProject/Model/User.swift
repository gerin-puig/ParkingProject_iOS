//
//  User.swift
//  ParkingProject
//
//  Created by Gerin Puig on 2021-05-17.
//
// Gerin Puig - 101343659
// Mayank Arya - 101300566

import Foundation
import FirebaseFirestoreSwift

struct User:Codable {
    //@DocumentID
    @DocumentID  var doc_id : String?
    var user_id:String
    var email:String
    var password:String
}
