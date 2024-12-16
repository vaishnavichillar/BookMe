//
//  OnboardOTPViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import UIKit

class OnboardOTPViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var OTPTxtfield: UITextField!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var OTPTimer: UILabel!
    @IBOutlet weak var resendOTP: UIStackView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var mobile: String!, verificationID: String?
    var countdownTimer: Timer!
    var expiredOTP = Bool()
    var otpFields: [UITextField] = []
    var time = 59
    
    var onboardData : VerifyOnboardPhoneModel?
    let loginViewModel = LoginViewModel()
    let viewModel = OTPViewModel()
    let helper = Helper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startTimer()
        self.getOTP()
        self.setup()
        self.setupAction()
        self.enableSignIn()
        self.disableSignIn()
        self.setupOTPFields()
    }
    
    func setup() {
        self.mainView.layer.cornerRadius = 10
        self.buttonImage.layer.cornerRadius = 10
    }
    
    func enableSignIn() {
        self.signInView.isUserInteractionEnabled = true
        self.signInView.alpha = 1.0
    }
    
    func disableSignIn() {
        self.signInView.isUserInteractionEnabled = false
        self.signInView.alpha = 0.5
    }
    
    func startIndicator() {
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
    }
    
    func stopIndicator() {
        self.indicatorView.isHidden = true
        self.indicator.stopAnimating()
    }
    
    func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(resendOTP(_:)))
        self.resendOTP.addGestureRecognizer(tap)
        self.resendOTP.isUserInteractionEnabled = true
        
        let registertap = UITapGestureRecognizer(target: self, action: #selector(regsiterAction))
        self.signInView.addGestureRecognizer(registertap)
        self.signInView.isUserInteractionEnabled = true
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
            field.layer.borderColor = UIColor.black.cgColor
            field.layer.borderWidth = 1
        }*/
    }
    
    func startTimer() {
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        self.OTPTimer.isHidden = false
        self.OTPTimer.text = "\(self.timeFormatted(self.time)) sec"

        if self.time != 0 {
            self.time -= 1
        }
        else {
            self.OTPTimer.text = "OTP Expired"
            self.expiredOTP = true
            self.OTPTxtfield.text = ""
            self.disableSignIn()
            self.endTimer()
            self.resendOTP.isHidden = false
            /*for field in otpFields {
                field.text = ""
            }*/
        }
    }
    
    func endTimer() {
        self.OTPTimer.isHidden = true
        self.countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func resendOTP(_ sender: UITapGestureRecognizer) {
        /*for fields in otpFields {
            fields.text = ""
        }*/
        self.OTPTxtfield.text = ""
        self.time = 59
        self.expiredOTP = false
        self.startTimer()
        self.resendOTP.isHidden = true
        self.viewModel.resendOTP(mobile: mobile) { ( returnValue, verificationID, _) in
            self.verificationID = verificationID
        }
    }
    
    func getOTP() {
        self.startIndicator()
        self.loginViewModel.generateOTP(mobile: mobile) { ( returnValue, verificationID, error) in
            self.stopIndicator()
            
            if verificationID.count != 0 {
                self.verificationID = verificationID
            }
            else {
                self.endTimer()
                Utility.showMessage(message: error ?? "", controller: self)
            }
        }
    }
    
    @objc func regsiterAction() {
        /*var otpText = ""

        for field in otpFields {
            if let text = field.text {
                otpText += text
            }
        }*/
        var otpText = self.OTPTxtfield.text ?? ""
        self.startIndicator()
        self.viewModel.verifyOTP(verificationID: verificationID!, verificationCode: otpText) { result in
            switch result {
            case .success(let authResult) :
                self.stopIndicator()
                self.viewModel.verifyOnboardDoctor(phone: self.mobile) { result in
                    
                    switch result {
                    case .success(let success):
                        self.onboardData = success
                        switch self.onboardData?.statusCode {
                            
                        case 200:
                            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardDoctorNameViewController") as? OnboardDoctorNameViewController else { return }
                            if let data = self.onboardData?.data {
                                vc.phone = self.mobile
                                vc.entityID = data.entityID
                                vc.doctorID = data.doctorID
                            }
                            self.navigationController?.pushViewController(vc, animated: false)
                            /*guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardSessionViewController") as? OnboardSessionViewController else { return }
                            self.navigationController?.pushViewController(vc, animated: false)*/
                        case 400:
                            let alertController = UIAlertController(title: "", message: self.onboardData?.message ?? "", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                 UIAlertAction in
                                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else { return }
                                self.navigationController?.pushViewController(vc, animated: false)
                             }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        default:
                            Utility.showMessage(message: self.onboardData?.message ?? "", controller: self)
                        }
                    case .failure(let failure):
                        self.stopIndicator()
                        Utility.showMessage(message: failure.localizedDescription, controller: self)
                    }
                }
            case .failure(let error) :
                self.stopIndicator()
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
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }

}

extension OnboardOTPViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow only digits
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        guard characterSet.isSubset(of: allowedCharacters) else {
            return false
        }

        // Handle backspace (deletion)
        if string.isEmpty {
            disableSignIn()
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
            enableSignIn()
        }
        else {
            disableSignIn()
        }
        return false // Prevent default behavior since we manually set the text
    }
}

/*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        
        guard characterSet.isSubset(of: allowedCharacters) else {
            return false
        }
        
        if !string.isEmpty && !expiredOTP {
            enableSignIn()
        }
        
        if string.isEmpty {
            disableSignIn()
        }
        
        /*if let currentText = textField.text, currentText.isEmpty && !string.isEmpty {
            textField.text = string
            moveToNextTextField(from: textField)
            return false
        } else if string.isEmpty {
            textField.text = ""
            moveToPreviousTextField(from: textField)
            return false
        }*/
    
    if let currentText = self.OTPTxtfield.text, currentText.isEmpty && !string.isEmpty {
        self.OTPTxtfield.text = string
        //moveToNextTextField(from: textField)
        return false
    } else if string.isEmpty {
        self.OTPTxtfield.text = ""
        //moveToPreviousTextField(from: textField)
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
