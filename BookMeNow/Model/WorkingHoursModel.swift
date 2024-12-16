//
//  WorkingHoursModel.swift
//  BookMeNow
//
//  Created by Neshwa on 08/02/24.
//

import Foundation

//enum Session: String, Codable {
//    case afternoon = "Afternoon"
//    case evening = "Evening"
//    case morning = "Morning"
//}

struct WorkingHoursModel : Codable {
    let statusCode : Int
    let message : String
    let data : WorkDataModel?
}

struct WorkDataModel : Codable {
    let result : [WorkResultModel]?
}

struct WorkResultModel : Codable {
    let dayStatus : Int?
    let day : String?
    let workSchedule : [WorkSchedule]?
}

struct WorkSchedule : Codable {
    let workScheduleID : Int?
    let day : String?
    let entityID : Int?
    let startTime, session, endTime : String?
    let doctorID, status : Int?
    let createdDateTime, updateDateTime, createdAt, updatedAt : String?
    
    enum CodingKeys : String, CodingKey {
        case workScheduleID = "work_schedule_id"
        case day
        case entityID = "entity_id"
        case startTime
        case session
        case endTime
        case doctorID = "doctor_id"
        case status
        case createdDateTime = "created_date_time"
        case updateDateTime = "update_date_time"
        case createdAt
        case updatedAt
    }
}
