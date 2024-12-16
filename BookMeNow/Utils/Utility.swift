//
//  NSObject.swift
//  BookMeNow
//
//  Created by Neshwa on 21/10/24.
//

import Foundation
import UIKit

class Utility: NSObject {
    
    class func showMessage(message:String, controller:UIViewController) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let regexPattern = "^[6-9]\\d{9,}$"

        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            let range = NSRange(location: 0, length: phoneNumber.utf16.count)
            return regex.firstMatch(in: phoneNumber, options: [], range: range) != nil
        }
        catch {
            print("Error creating regex: \(error)")
            return false
        }
    }
}
