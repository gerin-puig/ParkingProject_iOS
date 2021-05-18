//
//  ParkingModel.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-17.
//

import Foundation

struct Parking : Codable{
    var apt_number : String
    var building_code : String
    var date : String
    var geo_location : String
    var plate_number : String
    var number_of_hours : String
    var street_address : String
    var user_id : String
}
