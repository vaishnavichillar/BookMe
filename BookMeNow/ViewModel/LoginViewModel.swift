//
//  LoginViewModel.swift
//  BookMeNow
//
//  Created by Neshwa on 05/02/24.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewModel {
    
    func generateOTP(mobile: String, completion: @escaping (Bool,String, String?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber("+91\(mobile)", uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                if let nsError = error as? NSError {
                    switch nsError.code {
                    case AuthErrorCode.invalidPhoneNumber.rawValue:
                        completion(false,"", "Invalid phone number. Please try again later")
                        
                    case AuthErrorCode.networkError.rawValue:
                        completion(false,"", "Network request failed. Please try again later")
                        
                    case AuthErrorCode.tooManyRequests.rawValue:
                        completion(false,"", "Too many requests. Please try again later")
                        
                    case AuthErrorCode.operationNotAllowed.rawValue:
                        completion(false,"", "Operation not allowed. Please try again later")
                        
                    case AuthErrorCode.quotaExceeded.rawValue:
                        completion(false,"", "SMS quota exceeded. Please try again later")
                        
                    case AuthErrorCode.invalidRecaptchaAction.rawValue:
                        completion(false,"", "reCAPTCHA verification failed. Please try again later")
                        
                    case AuthErrorCode.invalidVerificationCode.rawValue:
                        completion(false,"", "Invalid verification code. Please try again later")
                        
                    case AuthErrorCode.invalidVerificationID.rawValue:
                        completion(false,"", "Invalid verification ID. Please try again later")
                        
                    default:
                        completion(false,"", "An error occurred. Please try again later")
                    }
                } else {
                    print("Error \(error.localizedDescription)")
                }
                
            }
            print("verificationId \(String(describing: verificationID))")
            if verificationID != nil {
                completion(true,verificationID ?? "", nil)
                //UserDefaults.standard.set(true, forKey: Constants.defaultIsLoggedIn)
            } else {
                completion(false,"", error?.localizedDescription)
            }
        }
    }
}
