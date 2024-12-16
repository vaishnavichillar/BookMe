//
//  LoginViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 05/02/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var signImage: UIImageView!
    @IBOutlet weak var callCustomerSupport: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var signInView: UIView!
    
    let viewModel = LoginViewModel()
    let navigation = Navigation()
    let apiManager = APIManager()
    let helper = Helper()
    var checkData:CheckUserModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        Helper.helper.ViewModification(myView: bottomView, mycorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], myCornerRadius: 15)
        self.setup()
        self.disableSignIn()
        self.setCountryCode()
        self.setupAction()
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: "versionNumber")
        //versionNumber.text = "Version : \(version)"
    }
    
    @objc func labelTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.url = "https://www.chillarpayments.com/terms-and-conditions.html"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func contactCustomerSupport() {
        self.helper.makeCall()
    }
    
    @objc func loginAction() {
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
        self.apiManager.checkUser(phone: mobile.text ?? "") { result in
            
            switch result {
            case .success(let success):
                self.checkData = success
                switch self.checkData?.statusCode {
                    
                case 200:
                    self.viewModel.generateOTP(mobile: self.mobile.text ?? "") { ( returnValue, verificationID, error) in
                        print(verificationID)
                        
                        self.indicator.stopAnimating()
                        self.indicatorView.isHidden = true
                       
                        if verificationID.count != 0 {
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                            vc.mobile = self.mobile.text
                            vc.verificationID = verificationID
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else {
                            Utility.showMessage(message: error ?? "", controller: self)
                        }
                    }
                case 404:
                    self.indicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    Utility.showMessage(message: self.checkData?.message ?? "", controller: self)
                default:
                    self.indicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    Utility.showMessage(message: self.checkData?.message ?? "", controller: self)
                }
            case .failure(let failure):
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
    
    func enableSignIn() {
        self.signInView.alpha = 1.0
        self.signInView.isUserInteractionEnabled = true
    }
    
    func disableSignIn() {
        self.signInView.alpha = 0.5
        self.signInView.isUserInteractionEnabled = false
    }

    func setCountryCode() {
        let label = UILabel()
        label.text = " +91 "
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.sizeToFit()
        self.mobile.leftView = label
        self.mobile.leftViewMode = .always
        self.mobile.layer.borderWidth = 1
        self.mobile.layer.borderColor = UIColor.black.cgColor
        self.mobile.layer.cornerRadius = 10
    }
    
    func setup() {
        self.indicatorView.isHidden = true
        self.mobile.delegate = self
        self.signImage.layer.cornerRadius = 10
    }
    
    func setupAction() {
        self.termsLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        self.termsLabel.addGestureRecognizer(tapGesture)
        
        let calltap = UITapGestureRecognizer(target: self, action: #selector(contactCustomerSupport))
        self.callCustomerSupport.addGestureRecognizer(calltap)
        self.callCustomerSupport.isUserInteractionEnabled = true
        
        let signTap = UITapGestureRecognizer(target: self, action: #selector(loginAction))
        self.signInView.addGestureRecognizer(signTap)
        self.signInView.isUserInteractionEnabled = true
    }
}

extension LoginViewController : UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Only allow numeric input
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        
        // If the new characters are not digits, reject the change
        guard characterSet.isSubset(of: allowedCharacters) else {
            return false
        }
        
        // Get the current text in the text field
        let currentString: NSString = (mobile.text ?? "") as NSString
        // Determine the new string if the replacement goes through
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        let strLength = newString.length
        
        // Restrict to exactly 10 digits //isValidPhoneNumber(newString as String)
        if strLength == 10 && Utility.isValidPhoneNumber(newString as String) {
            DispatchQueue.main.async {
                self.mobile.endEditing(true)
                self.enableSignIn()
            }
        }
        else if strLength > 10 {
            // Prevent adding more than 10 digits
            return false
        }
        else {
            disableSignIn()
        }
        return true
    }
}

/*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
            let characterSet = CharacterSet(charactersIn: string)
            guard characterSet.isSubset(of: allowedCharacters) else {
                return false
            }
        
        let maxLength = 10
        let currentString: NSString = (mobile.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        let strLength = newString.length
        
    if strLength == 10 && isValidPhoneNumber(newString as String) {
            DispatchQueue.main.async {
                self.mobile.endEditing(true)
                self.enableSignIn()
            }
        }
        else {
            disableSignIn()
        }
        return (newString.length) <= (maxLength)
}*/
