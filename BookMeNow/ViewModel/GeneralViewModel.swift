//
//  GeneralViewModel.swift
//  BookMeNow
//
//  Created by Neshwa on 03/09/24.
//

import Alamofire

class GeneralViewModel {
    
    let apiManager = APIManager()
    
    func updateDoctorAvailability(doctorID: Int, date: String, token: String, completion: @escaping (Result<UpdateEntityModel, Error>) -> Void) {
        
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token )"
        headers["Content-Type"] = "application/json"
        
        let body : Parameters = [
            "doctorId" : doctorID,
            "date" : date
        ]
        
        apiManager.postData(from: Endpoint.workAvailability, body: body, headers: headers, completion: completion)
    }
    
    func leaveMarkFunc(doctorID: Int, entityID: Int, token: String, completion: @escaping (Result<leaveModel, Error>) -> Void) {

        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token )"
        headers["Content-Type"] = "application/json"
        
        let body : Parameters = [
            "doctorId" : doctorID,
            "entityId" : entityID
        ]
        
        apiManager.postData(from: Endpoint.leaveList, body: body, headers: headers, completion: completion)
    }
    
    func listSpecialities( completion: @escaping (Result<SpecialityModel, Error>) -> Void) {
        apiManager.postData(from: Endpoint.listSpeciality, completion: completion)
    }
    
    func onboardDoctor(data: DoctorDetails, completion: @escaping (Result<OnboardResponseModel, Error>) -> Void) {
        
        let body: [String: Any] = [
                "doctor_phone": data.doctorPhone ?? "",
                "doctor_name": data.doctorName ?? "",
                "department_id": data.departmentID ?? 0,
                "consultation_time": data.consultationTime ?? 0,
                "entity_id": data.entityID ?? 0,
                "doctor_id": data.doctorID ?? 0,
                "workingHours": data.workingHours?.map { workingHour in
                    [
                        "day": workingHour.day,
                        "startTime": workingHour.startTime,
                        "endTime": workingHour.endTime,
                        "session": workingHour.session
                    ]
                } ?? []
            ]
        
        apiManager.postData(from: Endpoint.onboardDcotor, body: body, completion: completion)
    }
}
