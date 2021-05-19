//
//  User.swift
//  ParkingProject
//
//  Created by Gerin Puig on 2021-05-17.
//

import Foundation
import FirebaseFirestoreSwift

struct User:Codable {
    //@DocumentID
    var user_id:String
    var email:String
    var password:String
}
