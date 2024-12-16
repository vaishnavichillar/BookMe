//
//  ReportModel.swift
//  BookMeNow
//
//  Created by Neshwa on 12/02/24.
//

import Foundation

struct ReportModel: Codable {
    let statusCode: Int
    let message: String
    let data: ReportDataClass?
}


struct ReportDataClass: Codable {
    let bookingReport: [BookingReport]?
}


struct BookingReport: Codable {
    let customerName: String?
    let orderID: String?
    let amount, bookingStatus: Int?

    enum CodingKeys: String, CodingKey {
        case customerName
        case orderID = "orderId"
        case amount, bookingStatus
    }
}
