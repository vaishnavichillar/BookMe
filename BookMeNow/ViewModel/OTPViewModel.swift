//
//  OTPViewModel.swift
//  BookMeNow
//
//  Created by Neshwa on 06/02/24.
//

import Foundation
import FirebaseAuth
import Alamofire

class OTPViewModel {
    
    let apimanager = APIManager()
    
    func verifyOnboardDoctor(phone: String, completion: @escaping (Result<VerifyOnboardPhoneModel, Error>) -> Void) {
        
        let body : Parameters = [
            "phone" : phone
        ]
        
        apimanager.postData(from: Endpoint.phoneRegister, body: body, completion: completion)
    }
   
    
    func verifyOTP(verificationID: String, verificationCode: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signIn(with: credentials) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(authResult))
            }
        }
    }
    
    func resendOTP(mobile: String, completion: @escaping (Bool,String, Error?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber("+91\(mobile)", uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                //completion(false,"", error)
            }
            //UserDefaults.standard.set(verificationID, forKey: "verificationID")
            print("verificationId \(String(describing: verificationID))")
            if verificationID != nil {
                completion(true,verificationID ?? "", nil)
            } else {
                completion(false,"", error)
            }
        }
       
    }
    
}
