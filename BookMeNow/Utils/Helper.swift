//
//  Helper.swift
//  BookMeNow
//
//  Created by Neshwa on 08/02/24.
//

import Foundation
import UIKit

class Helper {
    
    static let helper = Helper()
    
    let apiManager = APIManager()
    
    func generateAccessToken(token: String) {
        apiManager.generateAccessToken(token: token) { response in
            
            switch response {
            case .success(let success):
                let accessToken = success.data?.accessToken
                UserDefaults.standard.set(accessToken, forKey: "accessToken")
            case .failure(let failure):
                print("Error generating access Token \(failure)")
            }
        }
    }
    
    func generateAccessToken(token: String, completion: @escaping (Bool, Error?, String?) -> Void) {
      apiManager.generateAccessToken(token: token) { response in
        switch response {
        case .success(let success):
            guard let data = success.data, let accessToken = data.accessToken, let refreshToken = data.refreshToken else {
            completion(false, NSError(domain: "AccessTokenError", code: 1, userInfo: ["message": "Failed to parse access token"]), nil)
            return
          }
            UserDefaults.standard.set(accessToken, forKey: "accessToken")
            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
            UserDefaults.standard.synchronize()
          completion(true, nil, accessToken)
        case .failure(let failure):
          completion(false, failure, nil)
        }
      }
    }
    
    func getRefreshToken() -> String {
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        return refreshToken ?? ""
    }
    
    func getAccessToken() -> String {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        return accessToken ?? ""
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
   
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
        
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Invalid response or status code")
                completion(nil)
                return
            }

            if let data = data, let image = UIImage(data: data) {
              
                completion(image)
            } else {
                print("No data received or unable to create image from data")
                completion(nil)
            }
        }.resume()
    }
    
    func formatDate(date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDateString = outputFormatter.string(from: date)
        print(formattedDateString)
        return formattedDateString
    }

    func makeCall() {
        let phoneNumber = "+919995699899"
        guard let url = URL(string: "tel://\(phoneNumber)") else {
            print("Invalid phone number")
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Cannot open URL")
        }
    }
    
    func getTopViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return nil
        }
        var topController: UIViewController = rootViewController
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    
    func presentAlertOnTopViewController(title: String, message: String, completion: @escaping () -> Void) {
        // Get the top-most presented view controller
        if let topController = getTopViewController() {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // Add an action button
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                completion()
            }
            alertController.addAction(okAction)
            
            // Present the alert
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func ViewModification(myView: UIView, mycorners: CACornerMask, myCornerRadius: Float?) {
        myView.layer.cornerRadius = CGFloat(myCornerRadius ?? 0.0)
        myView.layer.maskedCorners = mycorners
      }
}
