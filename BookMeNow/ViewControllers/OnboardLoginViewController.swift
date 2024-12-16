//
//  OnboardLoginViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import UIKit

class OnboardLoginViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var mobileNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupAction()
        self.enableSignIn()
        self.disableSignIn()
        self.setCountryCode()
    }
    
    @objc func regsiterAction() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardOTPViewController") as? OnboardOTPViewController else { return }
        vc.mobile = mobileNumber.text
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func setup() {
        self.mainView.layer.cornerRadius = 10
        self.buttonImage.layer.cornerRadius = 10
        self.mobileNumber.delegate = self
        self.mobileNumber.layer.borderWidth = 1
        self.mobileNumber.layer.borderColor = UIColor.black.cgColor
        self.mobileNumber.layer.cornerRadius = 10
    }
    
    func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(regsiterAction))
        self.signInView.addGestureRecognizer(tap)
        self.signInView.isUserInteractionEnabled = true
    }
    
    func enableSignIn() {
        self.signInView.isUserInteractionEnabled = true
        self.signInView.alpha = 1.0
    }
    
    func disableSignIn() {
        self.signInView.isUserInteractionEnabled = false
        self.signInView.alpha = 0.5
    }

    func setCountryCode() {
        let label = UILabel()
        label.text = " +91 "
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.sizeToFit()
        self.mobileNumber.leftView = label
        self.mobileNumber.leftViewMode = .always
    }
   
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

extension OnboardLoginViewController : UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
            let characterSet = CharacterSet(charactersIn: string)
            guard characterSet.isSubset(of: allowedCharacters) else {
                return false
            }
        let maxLength = 11
        let currentString: NSString = (mobileNumber.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        let strLength = newString.length
        
        if strLength >= 10 && Utility.isValidPhoneNumber(newString as String) {
            DispatchQueue.main.async {
                self.mobileNumber.endEditing(true)
                self.enableSignIn()
            }
        }
        else {
            disableSignIn()
        }
        return (newString.length) <= (maxLength)
    }
}

