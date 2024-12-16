//
//  SceneDelegate.swift
//  BookMeNow
//
//  Created by Neshwa on 03/02/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
//        window?.makeKeyAndVisible()
//        (UIApplication.shared.delegate as! AppDelegate).window = self.window
      /*  print("The loginStatus is \(UserDefaults.standard.bool(forKey: "loginStatus"))")
            if UserDefaults.standard.bool(forKey: "loginStatus") == true {
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    
                    let homeVC = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController"))
                    window.rootViewController = homeVC
                    window.makeKeyAndVisible()
                }
            }
            else {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    
                    let homeVC = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController"))
                    window.rootViewController = homeVC
                    window.makeKeyAndVisible()
                }
            }*/
        window?.makeKeyAndVisible()
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func isFirstLaunchOrReinstall() -> Bool {
        let hasRegistered = UserDefaults.standard.bool(forKey: "hasRegistered")
        return !hasRegistered // Returns true if the user hasn't registered (i.e., first time or after reinstall)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

