//
//  DoctorDetails.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import Foundation

struct DoctorDetails {
    
    var doctorPhone: String?
    var doctorName: String?
    var departmentID: Int?
    var consultationTime: Int?
    var entityID: Int?
    var doctorID: Int?
    var workingHours: [WorkingHour]?
    
    init(doctorPhone: String? = nil, doctorName: String? = nil, departmentID: Int? = nil, consultationTime: Int? = nil, entityID: Int? = nil, doctorID: Int? = nil, workingHours: [WorkingHour]? = nil) {
        self.doctorPhone = doctorPhone
        self.doctorName = doctorName
        self.departmentID = departmentID
        self.consultationTime = consultationTime
        self.entityID = entityID
        self.doctorID = doctorID
        self.workingHours = workingHours
    }
}

struct WorkingHour {
    var day: String?
    var startTime: String?
    var endTime: String?
    var session: String?
    
    init(day: String? = nil, startTime: String? = nil, endTime: String? = nil, session: String? = nil) {
        self.day = day
        self.startTime = startTime
        self.endTime = endTime
        self.session = session
    }
}


