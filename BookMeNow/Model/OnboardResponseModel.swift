//
//  OnboardResponseModel.swift
//  BookMeNow
//
//  Created by Neshwa on 21/09/24.
//

import Foundation

struct OnboardResponseModel: Codable {
    let statusCode: Int
    let message: String
    let data: OnboardData?
}

// MARK: - DataClass
struct OnboardData: Codable {
    let entityID, doctorID: Int?
    let phone, accessToken, refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case entityID = "entity_id"
        case doctorID = "doctor_id"
        case phone
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
