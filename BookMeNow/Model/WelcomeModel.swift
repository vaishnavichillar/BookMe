//
//  WelcomeModel.swift
//  BookMeNow
//
//  Created by Neshwa on 08/02/24.
//

import Foundation

struct WelcomeModel: Codable {
    let statusCode: Int
    let message: String
    let data: WelcomeDataModel?
}

struct WelcomeDataModel: Codable {
    let doctorID: Int?
    let phone: String?
    let bookingLinkStatus, consultationDuration, entityStatus, profileCompleted: Int?
    let entityDetails : [WelcomeEntityDetails]?

    enum CodingKeys: String, CodingKey {
        case doctorID = "doctor_id"
        case phone, bookingLinkStatus, consultationDuration
        case entityStatus
        case profileCompleted = "profile_completed"
        case entityDetails
    }
}

struct WelcomeEntityDetails : Codable {
    
    let entityID : Int?
    let entityName : String?
    let phone : String?
    let entityType : Int?
    
    enum CodingKeys : String, CodingKey {
        case entityID = "entityId"
        case entityName
        case phone
        case entityType
    }
}
