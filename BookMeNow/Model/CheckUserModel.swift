//
//  CheckUserModel.swift
//  BookMeNow
//
//  Created by Neshwa on 26/08/24.
//

import Foundation

struct CheckUserModel : Codable {
    let statusCode: Int
    let message: String
    let data: DataClass
}

struct DataClass: Codable {
    let phone: String
}

