//
//  HomeModel.swift
//  BookMeNow
//
//  Created by Neshwa on 12/02/24.
//

import Foundation

struct HomeModel: Codable {
    let statusCode: Int
    let message: String
    let data: HomeDataModel?
}

struct HomeDataModel: Codable {
    let appointmentList: [AppointmentList]?
    let totalBooking: Int?
    let completedAppointments: Int?
    let pendingAppointments: Int?
    let appointmentDate: String?
    let doctorName : String?
    let entityDetails: [EntityDetails]?
}

struct AppointmentList: Codable {
    let bookingID: Int?
    let timeSlot, customerName, customerPhone: String?
    let bookingStatus: Int?

    enum CodingKeys: String, CodingKey {
        case bookingID = "bookingId"
        case timeSlot, customerName, bookingStatus, customerPhone
    }
}

struct EntityDetails: Codable {
    let entityID: Int?
    let entityName, phone: String?
    let entityType: Int?

    enum CodingKeys: String, CodingKey {
        case entityID = "entityId"
        case entityName, phone, entityType
    }
}
