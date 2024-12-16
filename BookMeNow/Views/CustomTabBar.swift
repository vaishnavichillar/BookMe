//
//  CustomTabBar.swift
//  BookMeNow
//
//  Created by Neshwa on 04/02/24.
//

import Foundation
import UIKit

class CustomTabBar : UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.delegate = self
        setupMiddleButton()
    }
    
    @objc func navigateToPhotos() {
        print("sell button tapped")
    }
    
    func setupMiddleButton() {
        let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 22, y: -20, width: 50, height: 50))
        middleButton.layer.backgroundColor = UIColor.cyan.cgColor
        //middleButton.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = UIImage(systemName: "calendar")
        middleButton.addSubview(imageView)
        imageView.center = CGPoint(x: middleButton.bounds.size.width / 2, y: middleButton.bounds.size.height / 2)

        middleButton.layer.cornerRadius = middleButton.frame.width / 2
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.1
        middleButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.tabBar.addSubview(middleButton)
        
        middleButton.addTarget(self, action: #selector(navigateToPhotos), for: .touchUpInside)
        self.view.layoutIfNeeded()
    }
}
