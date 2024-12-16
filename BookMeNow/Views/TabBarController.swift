//
//  TabBarController.swift
//  BookMeNow
//
//  Created by Neshwa on 06/02/24.
//

import Foundation
import UIKit

class TabController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
    }
    
    private func setupTabs() {
        
        let logout = self.createNavigationController(with: "Logout", and: UIImage(systemName: "power"), vc: LogoutViewController())
        let account = self.createNavigationController(with: "Account", and: UIImage(systemName: "person.circle"), vc: ProfileViewController())
        let report = self.createNavigationController(with: "Report", and: UIImage(systemName: "bolt"), vc: ReportViewController())
        let settings = self.createNavigationController(with: "Settings", and: UIImage(systemName: "gear"), vc: SettingsViewController())
        self.setViewControllers([account, report, settings, logout], animated: true)
    }
    
    private func createNavigationController(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        return nav
    }
}
