//
//  GeneralRequest.swift
//  BitnetVehicle
//
//  Created by József Jagicza on 2021. 04. 08..
//

import Foundation

class GeneralRequest: APIRequest {
    var method = RequestType.GET
    var path = ""
    var parameters = [String: String]()

    init(format: String, page: String) {
        parameters["format"] = format
        parameters["page"] = page
    }
}
