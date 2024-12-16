//
//  OTPViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 05/02/24.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var OTPField1: UITextField!
    @IBOutlet weak var OTPField2: UITextField!
    @IBOutlet weak var OTPField3: UITextField!
    @IBOutlet weak var OTPField4: UITextField!
    @IBOutlet weak var OTPField5: UITextField!
    @IBOutlet weak var OTPField6: UITextField!
    @IBOutlet weak var OTPTxtfield: UITextField!
    @IBOutlet weak var continueButton: UIView!
    @IBOutlet weak var OTPTimer: UILabel!
    @IBOutlet weak var resendOTP: UIStackView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var signinView: UIView!
    
    var otpFields: [UITextField] = []
    var countdownTimer: Timer!
    var mobile: String!, verificationID: String?
    var expiredOTP = Bool()
    let currentDate = Date()
    var time = 59
    
    let viewModel = OTPViewModel()
    let apiManager = APIManager()
    var userData : VerifyUserModel?
    let helper = Helper()
    
    var refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    let version = UserDefaults.standard.string(forKey: "versionNumber") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        Helper.helper.ViewModification(myView: bottomView, mycorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], myCornerRadius: 15)
        self.setup()
        self.setupAction()
        self.disableButton()
        self.indicatorView.isHidden = true
        self.setupOTPFields()
        self.startTimer()
    }
    
    @objc func resendOTP(_ sender: UITapGestureRecognizer) {
        /*for fields in otpFields {
            fields.text = ""
        }*/
        self.OTPTxtfield.text = ""
        self.expiredOTP = false
        self.startTimer()
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
        self.resendOTP.isHidden = true
        self.viewModel.resendOTP(mobile: mobile) { ( returnValue, verificationID, _) in
            self.verificationID = verificationID
        }
        self.indicator.stopAnimating()
        self.indicatorView.isHidden = true
    }
    
    @objc func updateTime() {
        self.OTPTimer.text = "\(timeFormatted(self.time)) sec"

        if self.time != 0 {
            self.time -= 1
        }
        else {
            self.OTPTimer.text = "OTP Expired"
            self.expiredOTP = true
            /*for field in otpFields {
                field.text = ""
            }*/
            self.OTPTxtfield.text = ""
            self.disableButton()
            self.endTimer()
            self.resendOTP.isHidden = false
        }
    }
    
    @objc func continueAction() {
        /*var otpText = ""
        for field in otpFields {
            if let text = field.text {
                otpText += text
            }
        }*/
        var otpText = self.OTPTxtfield.text ?? ""
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
        print("verificationId :\(verificationID ?? "invalid ID")")
        
        self.viewModel.verifyOTP(verificationID: verificationID!, verificationCode: otpText) { result in
            
            switch result {
            case .success(let authResult) :
                print("OTP verification success: \(authResult!)")
                self.verifyUser(phone: self.mobile)
            case .failure(let error) :
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                let alert = UIAlertController(title: "Invalid OTP", message: "Please enter a valid OTP", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    for otpField in self.otpFields {
                        otpField.text = ""
                    }
                })
                self.navigationController?.present(alert, animated: true)
            }
        }
    }
    
    func setup() {
        self.resendOTP.isHidden = true
        self.buttonImage.layer.cornerRadius = 10
    }
    
    func setupAction() {
        let signTap = UITapGestureRecognizer(target: self, action: #selector(continueAction))
        self.signinView.addGestureRecognizer(signTap)
        self.signinView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resendOTP(_:)))
        self.resendOTP.isUserInteractionEnabled = true
        self.resendOTP.addGestureRecognizer(tapGesture)
    }
    
    func enableButton() {
        self.continueButton.alpha = 1.0
        self.continueButton.isUserInteractionEnabled = true
    }
    
    func disableButton() {
        self.continueButton.alpha = 0.5
        self.continueButton.isUserInteractionEnabled = false
    }
    
    func setupOTPFields() {
        self.OTPTxtfield.delegate = self
        self.OTPTxtfield.textAlignment = .center
        self.OTPTxtfield.layer.cornerRadius = 10
        self.OTPTxtfield.layer.borderWidth = 1
        self.OTPTxtfield.layer.borderColor = UIColor.black.cgColor
        /*otpFields = [OTPField1, OTPField2, OTPField3, OTPField4, OTPField5, OTPField6]
        for field in otpFields {
            field.delegate = self
            field.layer.masksToBounds = true
            field.textContentType = .oneTimeCode
            field.layer.cornerRadius = 10
            let hexColorCode = "6B8CFF"
            //let color = UIColor(hex: hexColorCode).cgColor
            field.layer.borderColor = UIColor.black.cgColor
            field.layer.borderWidth = 1
        }*/
    }
    
    func startTimer() {
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }

    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func maskPhoneNumber(_ phoneNumber: String) -> String {
        guard phoneNumber.count >= 10 else {
            return "Invalid phone number"
        }
        let maskedCharacters = String(repeating: "*", count: phoneNumber.count - 4)
        let visiblePart = phoneNumber.suffix(4)
        let maskedPhoneNumber = maskedCharacters + String(visiblePart)
        return maskedPhoneNumber
    }
    
    func verifyUser(phone: String) {
        
        self.apiManager.verifyUser(phone: phone) { response in
            switch response {
            case .success(let data):
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                self.endTimer()
                self.userData = data
                
                UserDefaults.standard.set(self.currentDate, forKey: "lastLoginDate")
                UserDefaults.standard.setValue(self.userData?.data?.accessToken, forKey: "accessToken")
                UserDefaults.standard.setValue(self.userData?.data?.refreshToken, forKey: "refreshToken")
                let statusCode = self.userData?.statusCode
                
                switch statusCode {
                case "200":
                    UserDefaults.standard.setValue(self.mobile, forKey: "phone")
                    UserDefaults.standard.set(true, forKey: "loginStatus")
                    
                    if let data = self.userData?.data {
                       UserDefaults.standard.set(data.entityID, forKey: "entityID")
                       UserDefaults.standard.set(data.doctorID, forKey: "doctorID")
                       guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                        vc.entityID = data.entityID
                        vc.doctorID = data.doctorID ?? 0
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case "403":
                    self.helper.generateAccessToken(token: self.refreshToken) { flag, response, _  in
                        switch flag {
                        case true:
                            self.verifyUser(phone: phone)
                        case false:
                            print("Error generating token")
                        }
                    }
                default:
                    self.indicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    Utility.showMessage(message: self.userData?.message ?? "", controller: self)
            }
            case .failure(let error):
                self.endTimer()
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
}

extension OTPViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Allow only digits
            let allowedCharacters = CharacterSet(charactersIn: "1234567890")
            let characterSet = CharacterSet(charactersIn: string)
            guard characterSet.isSubset(of: allowedCharacters) else {
                return false
            }

            // Handle backspace (deletion)
            if string.isEmpty {
                self.disableButton()
                return true // Allow deletion
            }

            // Get the current text and calculate the updated text
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // Limit to 6 characters
            if updatedText.count > 6 {
                return false
            }
            /*else {
                return true
            }*/

            // Update the text field with the new text
            textField.text = updatedText

            // Enable or disable sign-in based on input
            if updatedText.count == 6 && !expiredOTP {
                self.OTPTxtfield.resignFirstResponder()
                self.enableButton()
            }
            else {
                self.disableButton()
            }
            return false // Prevent default behavior since we manually set the text
        }
}

/* func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        
        guard characterSet.isSubset(of: allowedCharacters) else {
            return false
        }
        
        if !string.isEmpty && !expiredOTP {
            enableButton()
        }
        
        if string.isEmpty {
            disableButton()
        }
        
        if let currentText = textField.text, currentText.isEmpty && !string.isEmpty {
            textField.text = string
            moveToNextTextField(from: textField)
            return false
        } else if string.isEmpty {
            textField.text = ""
            moveToPreviousTextField(from: textField)
            return false
        }
        
        return false
    }

    func moveToNextTextField(from textField: UITextField) {
        switch textField {
        case OTPField1:
            OTPField2.becomeFirstResponder()
        case OTPField2:
            OTPField3.becomeFirstResponder()
        case OTPField3:
            OTPField4.becomeFirstResponder()
        case OTPField4:
            OTPField5.becomeFirstResponder()
        case OTPField5:
            OTPField6.becomeFirstResponder()
        case OTPField6:
            OTPField6.resignFirstResponder()
        default:
            break
        }
    }

    func moveToPreviousTextField(from textField: UITextField) {
        switch textField {
        case OTPField2:
            OTPField1.becomeFirstResponder()
        case OTPField3:
            OTPField2.becomeFirstResponder()
        case OTPField4:
            OTPField3.becomeFirstResponder()
        case OTPField5:
            OTPField4.becomeFirstResponder()
        case OTPField6:
            OTPField5.becomeFirstResponder()
        case OTPField1:
            OTPField1.resignFirstResponder()
        default:
            break
        }
    }*/
