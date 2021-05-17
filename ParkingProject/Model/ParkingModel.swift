//
//  ParkingModel.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-17.
//

import Foundation

struct Parking : Codable{
    var apartmentNumber : String
    var buildingCode : String
    var date : String
    var geoLocation : String
    var plateNumber : String
    var numberOfHours : String
    var streetAddress : String
    var userId : String
}
