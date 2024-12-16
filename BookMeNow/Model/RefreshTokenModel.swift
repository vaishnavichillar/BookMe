//
//  RefreshTokenModel.swift
//  BookMeNow
//
//  Created by Neshwa on 07/02/24.
//

import Foundation

struct RefreshRequestBody: Encodable {
}

struct RefreshTokenModel : Codable {
    var statusCode : Int?
    var message : String?
    var data : RefreshDataModel?
}

struct RefreshDataModel : Codable {
    var accessToken : String?
    var refreshToken : String?
}
