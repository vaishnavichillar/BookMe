//
//  SpecialityModel.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import Foundation

struct SpecialityModel: Codable {
    let statusCode: Int
    let message: String
    let data: [SpecialityData]?
}

struct SpecialityData: Codable {
    let departmentID: Int?
    let departmentName: String?
    let status: Int?

    enum CodingKeys: String, CodingKey {
        case departmentID = "department_id"
        case departmentName = "department_name"
        case status
    }
}
