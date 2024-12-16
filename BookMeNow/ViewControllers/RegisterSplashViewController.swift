//
//  RegisterSplashViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import UIKit

class RegisterSplashViewController: UIViewController {

    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var arrowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerView.layer.cornerRadius = self.registerView.frame.height / 2
        self.arrowView.layer.cornerRadius = arrowView.frame.height / 2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(regsiterAction))
        registerView.addGestureRecognizer(tap)
        registerView.isUserInteractionEnabled = true
    }
    
    @objc func regsiterAction() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardLoginViewController") as? OnboardLoginViewController else { return }
        navigationController?.pushViewController(vc, animated: false)
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}
