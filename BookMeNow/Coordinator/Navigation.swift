//
//  Navigation.swift
//  BookMeNow
//
//  Created by Neshwa on 06/02/24.
//

import Foundation
import UIKit

class Navigation {
    
    func pushViewController<T: UIViewController>(_ navigationController: UINavigationController, viewControllerType: T.Type, animated: Bool = true) {
        let viewController = viewControllerType.init()
        navigationController.pushViewController(viewController, animated: animated)
    }
}
