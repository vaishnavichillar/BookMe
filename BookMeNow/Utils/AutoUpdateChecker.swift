//
//  AutoUpdateChecker.swift
//  BookMeNow
//
//  Created by Neshwa on 05/09/24.
//

import UIKit

class AutoUpdateChecker {

    static let shared = AutoUpdateChecker()

    let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] ?? ""
    let appID = "6514323157"  // Replace with your app's App Store ID

    // Function to check for an update
    func checkForUpdate(completion: @escaping (Bool, String?) -> Void) {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            completion(false, nil)
            return
        }

        let urlString = "https://itunes.apple.com/lookup?bundleId=\(identifier)"
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(false, nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String {

                    if currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending {
                        completion(true, appStoreVersion)
                    } else {
                        completion(false, nil)
                    }
                } else {
                    completion(false, nil)
                }
            } catch {
                completion(false, nil)
            }
        }.resume()
    }

    // Show a mandatory update alert
    func showMandatoryUpdateAlert(on viewController: UIViewController, newVersion: String) {
        let alertController = UIAlertController(title: "Mandatory Update",
                                                message: "A new version (\(newVersion)) of the app is available. You must update to continue using the app.",
                                                preferredStyle: .alert)

        let updateAction = UIAlertAction(title: "Update Now", style: .default) { _ in
            if let url = URL(string: "https://apps.apple.com/app/id\(self.appID)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        // No cancel action to enforce the update
        alertController.addAction(updateAction)

        DispatchQueue.main.async {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }

    // Function to close the app if update is not performed
    func closeApp() {
        exit(0)
    }
}
