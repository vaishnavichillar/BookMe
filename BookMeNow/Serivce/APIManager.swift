//
//  APIManager.swift
//  BookMeNow
//
//  Created by Neshwa on 07/02/24.
//

import Foundation
import UIKit
import Alamofire

class APIManager {
    
    private var reachabilityManager: NetworkReachabilityManager?
    
    init() {
        reachabilityManager = NetworkReachabilityManager()
        }
    
    //MARK: To chech whether network available or not before api request
    func isNetworkReachable() -> Bool {
           return reachabilityManager?.isReachable ?? false
       }
    
    //MARK: Function to show alert
    private func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Assuming you have access to the topmost view controller
        if let topViewController = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow})
                .first?.rootViewController {
                
                topViewController.present(alertController, animated: true, completion: nil)
            }
        }
    
    //MARK: Generics function for POST method Api Integration
    func postData<T: Codable>(from endPoint: Endpoint, body: Parameters? = nil, token: String? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard isNetworkReachable() else {
            showAlert(title: "Network Error", message: "No network connection")
            completion(.failure(CustomError.noConnection))
            return
        }

        let url = "\(baseURL)\(endPoint.path)"
        print("The url is \(url)")
        print("The headers is \(headers)")
        print("The body is \(body)")
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: T.self) { response in
                print("The response result is \(response)")
                switch response.result {
                case .success(let json):
                    print("Raw JSON is \(json)")
                    completion(.success(json))
                    //completion(.success(json as! T))
                case .failure(let error):
                    completion(.failure(error))
                } //
            }
    }
    
    //MARK: Generics function for POST method Api Integration
    func fetchData<T: Codable>(from endPoint: Endpoint, token: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard isNetworkReachable() else {
            showAlert(title: "Network Error", message: "No network connection")
            return
        }
        
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token)"
        
        let url = "\(baseURL)\(endPoint.path)"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: Check whether phone number is registered or not
    func checkUser(phone: String, completion: @escaping (Result<CheckUserModel, Error>) -> Void) {
        
        let body: Parameters = [
            "phone": phone
        ]
        
        postData(from: Endpoint.checkUser, body: body, completion: completion)
        
    }
   
    
    //MARK: Check whether user registered or not
    func verifyUser(phone: String, completion: @escaping (Result<VerifyUserModel, Error>) -> Void) {
     
        let body: Parameters = [
            "phone": phone
        ]
        
        postData(from: Endpoint.verifyUser, body: body, completion: completion)
    }
    
    //MARK: Regenerate access token
    
    func generateAccessToken(token: String, completion: @escaping (Result<RefreshTokenModel, Error>) -> Void) {
        
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token)"
        headers["Content-Type"] = "application/json"
        
        postData(from: Endpoint.refershToken, token: token, headers: headers, completion: completion)
    }
    
    //MARK: Regenerate access token
    
    func getProfile(phone: String, token: String, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token)"
        headers["Content-Type"] = "application/json"
        
        let body: Parameters = [
            "phone": phone
        ]

        postData(from: Endpoint.getProfile, body: body, token: token, headers: headers, completion: completion)
    }
    
    //MARK: Get data for welcome page
    
    func getWelcomeData(token: String, completion: @escaping (Result<WelcomeModel, Error>) -> Void) {
        fetchData(from: Endpoint.generalSettings, token: token, completion: completion)
    }
    
    //MARK: Get working hours
    
    func getWorkingHours(doctorID: String, entityID: String, token: String, completion: @escaping (Result<WorkingHoursModel, Error>) -> Void) {
        
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token)"
        headers["Content-Type"] = "application/json"
        
        let body: Parameters = [
            "doctor_id": doctorID,
            "entity_id": entityID
        ]

        postData(from: Endpoint.getWorkingHours, body: body, token: token, headers: headers, completion: completion)
    }
    
    func getBankData(token: String, completion: @escaping (Result<BankDetailsModel, Error>) -> Void) {
       
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token)"
        headers["Content-Type"] = "application/json"
        
        postData(from: Endpoint.bankdata, token: token, headers: headers, completion: completion)
    }
    
    func getBookingLink(token: String, completion: @escaping (Result<BookingLinkModel, Error>) -> Void) {
        
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token)"
        headers["Content-Type"] = "application/json"
        
        postData(from: Endpoint.getBookingLink, token: token, headers: headers, completion: completion)
    }
    
    func getHomeData(doctorId: Int, date: String, entityID: Int?, token: String, completion: @escaping (Result<HomeModel, Error>) -> Void) {
        
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token )"
        headers["Content-Type"] = "application/json"
        
        let body: Parameters = [
            "doctorId": doctorId,
            "date" : date,
            "entityId" : entityID ?? 0
        ]
        
        print("The headers is \(headers)\n body is \(body)")
        
        postData(from: Endpoint.listBooking, body: body, token: token, headers: headers, completion: completion)
    }
    
    func getbookingReport(doctorId: String, date: String, token: String, completion: @escaping (Result<ReportModel, Error>) -> Void) {
        
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token)"
        headers["Content-Type"] = "application/json"
        
        let body: Parameters = [
            "doctorId": doctorId,
            "date" : date
        ]
        
        postData(from: Endpoint.bookingReport ,body: body, token: token, headers: headers, completion: completion)
    }
    
    func getBookingUpdateStatus(bookingID: Int, token: String, completion: @escaping (Result<BookingUpdateModel, Error>) -> Void) {
        
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token)"
        headers["Content-Type"] = "application/json"
        
        let body: Parameters = [
            "bookingId": bookingID
        ]
        
        postData(from: Endpoint.updateBooking, body: body, token: token, headers: headers, completion: completion)
    }
    
    func getUpdateEntityStatus(token: String, completion: @escaping (Result<UpdateEntityModel, Error>) -> Void) {
        
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(token)"
        headers["Content-Type"] = "application/json"
        
        postData(from: Endpoint.updateEntity, token: token, headers: headers, completion: completion)
    }
}

/* func fetchData<T: Codable>(from endPoint: Endpoint, body: [String : Any]?, token: String, completion: @escaping (Result<T, Error>) -> Void) {
    
    let url = "\(baseURL)\(endPoint.path)"
    let requestUrl : String?
    
    if let queryParams = body?.compactMap({ "\($0)=\($1)" }).joined(separator: "&") {
         requestUrl = url + "?" + queryParams
        // Use requestUrl for further processing
    } else {
         requestUrl = url
        // Use requestUrl for further processing
    }
    var request = URLRequest(url: URL(string: requestUrl!)!)
    request.httpMethod = HTTPMethod.post.rawValue // Use GET method
    //request.httpBody = try? JSONSerialization.data(withJSONObject: body as Any) // Encode parameters as JSON data

    // Set the content type header
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    // Make the request using Alamofire
    AF.request(request).responseDecodable(of: T.self) { response in
        switch response.result {
        case .success(let data):
            completion(.success(data))
        case .failure(let error):
            completion(.failure(error))
        }
    }
//        AF.request(url, method: .get, parameters: body, encoding: URLEncoding.httpBody, headers: headers)
//            .responseDecodable(of: T.self) { response in
//                switch response.result {
//                case .success(let data):
//                    completion(.success(data))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
} */

enum CustomError : Error {
    case noConnection
}

