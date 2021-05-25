//
//  ParkingModel.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-17.
//
// Gerin Puig - 101343659
// Mayank Arya - 

import Foundation

struct Parking : Codable{
    
    var building_code : String
    var date : String
    var geo_location_lat : String
    var geo_location_long : String
    var plate_number : String
    var number_of_hours : String
    var street_address : String
    var user_id : String
    var suit_no : String
}
