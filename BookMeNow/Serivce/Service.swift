//
//  Service.swift
//  BookMeNow
//
//  Created by Neshwa on 07/02/24.
//

import Foundation

let baseURL = "http://booking.chillarpayments.com:8081/api/v1/"

enum Endpoint {
    
    case checkUser
    case verifyUser
    case refershToken
    case getProfile
    case getWorkingHours
    case generalSettings
    case bankdata
    case listBooking
    case bookingReport
    case updateBooking
    case updateEntity
    case getBookingLink
    case workAvailability
    case listSpeciality
    case phoneRegister
    case onboardDcotor
    case leaveList
    
    var path : String {
        
        switch self {
            
        case .checkUser:
            return "auth/user-check"
            
        case .verifyUser:
            return "auth/register"
            
        case .refershToken:
            return "auth/refreshToken"
            
        case .getProfile:
            return "auth/getProfile"
            
        case .getWorkingHours:
            return "work/get-work-schedule"
            
        case .generalSettings:
            return "auth/generalSettings"
            
        case .bankdata:
            return "auth/bankdata"
            
        case .listBooking:
            return "booking/listBooking"
            
        case .bookingReport:
            return "booking/bookingReport"
            
        case .updateBooking:
            return "booking/updateBooking"
            
        case .updateEntity:
            return "auth/update-status"
            
        case .getBookingLink:
            return "booking/get-booking-link"
            
        case .workAvailability:
            return "work/doc-availability"
            
        case .listSpeciality:
            return "auth/list-specialities"
            
        case .phoneRegister:
            return "auth/phone-register"
            
        case .onboardDcotor:
            return "auth/onboard-doctor"
            
        case .leaveList:
            return "auth/list-leave"
        }
    }
}
