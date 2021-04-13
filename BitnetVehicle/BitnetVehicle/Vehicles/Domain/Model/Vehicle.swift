//
//  Vehicle.swift
//  BitnetVehicle
//
//  Created by József Jagicza on 2021. 04. 08..
//

import Foundation

struct Vehicles: Codable {
    let count:          Int
    let message:        String
    let searchCriteria: Int?
    let results:        [Vehicle]?

    private enum CodingKeys: String, CodingKey {
        case count          = "Count"
        case message        = "Message"
        case searchCriteria = "SearchCriteria"
        case results        = "Results"
    }
}

struct Vehicle: Codable {
    let country:        String
    let mfrCommonName:  String?
    let mfrId:          Int
    let mfrName:        String
    let vehicleType:    [VehicleType]?
    let webPages:       [String]?

    private enum CodingKeys: String, CodingKey {
        case country            = "Country"
        case mfrCommonName      = "Mfr_CommonName"
        case mfrId              = "Mfr_ID"
        case mfrName            = "Mfr_Name"
        case vehicleType        = "VehicleTypes"
        case webPages           = "web_pages"
    }
    
    var description: String {
        get {
            if let webPage = webPages?.first {
                return "\(country) • \(webPage)"
            } else {
                return country
            }
        }
    }
}

struct VehicleType: Codable {
    let isPrimary:  Bool
    let name:       String

    private enum CodingKeys: String, CodingKey {
        case isPrimary = "IsPrimary"
        case name      = "Name"
    }
}
