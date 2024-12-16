//
//  UpdateEntityModel.swift
//  BookMeNow
//
//  Created by Neshwa on 13/02/24.
//

import Foundation

struct UpdateEntityModel : Codable {
    let statusCode : Int
    let message : String
}

struct leaveModel : Codable {
    let statusCode : Int
    let message : String
    let data : [String]
}
