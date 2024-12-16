//
//  SplashViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 08/02/24.
//

import UIKit

class SplashViewController: UIViewController {
    
    let story = UIStoryboard(name: "Main", bundle: nil)
    let status = UserDefaults.standard.bool(forKey: "loginStatus")
    let entityID = UserDefaults.standard.integer(forKey: "entityID")
    let doctorID = UserDefaults.standard.integer(forKey: "doctorID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AutoUpdateChecker.shared.checkForUpdate { isUpdateAvailable, newVersion in
            
            if !isUpdateAvailable {
                
                if let version = newVersion {
                    AutoUpdateChecker.shared.showMandatoryUpdateAlert(on: self, newVersion: version)
                }
                else {
                    self.opanApp()
                }
            }
            else {
                self.opanApp()
            }
        }
    }
    
    
    func opanApp() {
       /* DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("The status of the splashPage is \(self.status)")
            if self.status {
                let vc = self.story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                vc.entityID = self.entityID
                vc.doctorID = self.doctorID
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
//                let vc = self.story.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
//                self.navigationController?.pushViewController(vc, animated: true)
                //LoginViewController
                                let vc = self.story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                self.navigationController?.pushViewController(vc, animated: true)
            }
        }*/
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("The loginStatus of splashPage is \(UserDefaults.standard.bool(forKey: "loginStatus"))")
            print("The entityId of splashPage is \(self.entityID) and doctorID is \(self.doctorID)")
            if UserDefaults.standard.bool(forKey: "loginStatus") == true {
                        // User is logged in, redirect to HomeViewController
                let vc = self.story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                vc.entityID = self.entityID
                vc.doctorID = self.doctorID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = self.story.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

