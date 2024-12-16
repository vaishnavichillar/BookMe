//
//  VerifyOnboardPhoneModel.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import Foundation

struct VerifyOnboardPhoneModel: Codable {
    let statusCode: Int
    let message: String
    let data: VerifyOnboardPhoneData?
}

struct VerifyOnboardPhoneData: Codable {
    let entityID, doctorID, profileCompleted: Int?
    let doctorPhone: String?

    enum CodingKeys: String, CodingKey {
        case entityID = "entity_id"
        case doctorID = "doctor_id"
        case doctorPhone
        case profileCompleted = "profile_completed"
    }
}
