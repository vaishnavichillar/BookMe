//
//  HomeViewModel.swift
//  BookMeNow
//
//  Created by Neshwa on 07/02/24.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeViewModel {
    
    func logoutUser(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            print("User logged out successfully")
            completion(true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(false)
        }
    }
    
    func getBookingLink() {
        
    }

}
