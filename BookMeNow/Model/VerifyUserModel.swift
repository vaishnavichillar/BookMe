//
//  VerifyUserModel.swift
//  BookMeNow
//
//  Created by Neshwa on 07/02/24.
//

import Foundation

struct VerifyUserRequestModel : Codable {
    var phone: String?
    var accessToken: String?
}

struct VerifyUserModel : Codable {
    var statusCode : String?
    var message : String?
    var data : DataModel?
}

struct DataModel : Codable {
    let entityID, doctorID, profileCompleted, status, entityType : Int?
    let phone, accessToken, refreshToken : String?
    let entityDetails : [VerifyEntityDetails]?
    
    enum CodingKeys : String, CodingKey {
        case entityID = "entity_id"
        case doctorID = "doctor_id"
        case phone
        case profileCompleted = "profile_completed"
        case status
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case entityType = "entity_type"
        case entityDetails
    }
}

struct VerifyEntityDetails : Codable {
    
    let entityID, entityType : Int?
    let entityName, phone : String?
    
    enum CodingKeys : String, CodingKey {
        case entityID = "entityId"
        case entityName
        case phone 
        case entityType
    }
}

enum NetworkError: Error {
    case noConnection
    case invalidBody
    // Add more cases as needed
}


