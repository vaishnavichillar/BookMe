//
//  RegisterViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 23/08/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var versionNumber: UILabel!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var signinView: UIView!
    @IBOutlet weak var mainView: UIStackView!
    @IBOutlet weak var gradientImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        //versionNumber.text = "Version: \(version)"
        setup()
    }
    
    func setup() {
        self.gradientImage.layer.cornerRadius = 10
        self.signinView.layer.cornerRadius = 10
        self.registerView.layer.cornerRadius = 10
        self.mainView.layer.cornerRadius = 10
        self.mainView.layer.borderWidth = 1
        self.mainView.layer.borderColor = UIColor.appTheme.cgColor
        
        Helper.helper.ViewModification(myView: bottomView, mycorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], myCornerRadius: 15)
        
        let signTap = UITapGestureRecognizer(target: self, action: #selector(signinAction))
        self.signinView.addGestureRecognizer(signTap)
        self.signinView.isUserInteractionEnabled = true
        
        let registerTap = UITapGestureRecognizer(target: self, action: #selector(registerAction))
        self.registerView.addGestureRecognizer(registerTap)
        self.registerView.isUserInteractionEnabled = true
    }
    
    @objc func signinAction() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func registerAction() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterSplashViewController") as? RegisterSplashViewController else { return }
        navigationController?.pushViewController(vc, animated: false)
    }
}
