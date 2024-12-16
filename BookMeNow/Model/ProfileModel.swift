//
//  ProfileModel.swift
//  BookMeNow
//
//  Created by Neshwa on 07/02/24.
//

import Foundation

struct ProfileModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: ProfileDataModel?
}


struct ProfileDataModel: Codable {
   
    let phone, doctorName, qualification : String?
    let doctorID : Int?
    let profileImageURL : String?
    let description, departmentName : String?
    let additionalInfo : [AdditionalData]?

    enum CodingKeys: String, CodingKey {
        
        case phone
        case doctorName = "doctor_name"
        case qualification
        case doctorID = "doctor_id"
        case profileImageURL = "profileImageUrl"
        case description, departmentName
        case additionalInfo
    }
}

struct AdditionalData : Codable {
    
    let entityId, entityType, consultationTime : Int?
    let entityName, entityPhone : String?
    let consultationCharge: Double?
    
    enum CodingKeys: String, CodingKey {
        case entityId
        case entityName
        case entityPhone
        case entityType
        case consultationCharge
        case consultationTime
    }
}
