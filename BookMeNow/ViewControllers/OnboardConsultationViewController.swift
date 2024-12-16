//
//  OnboardConsultationViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import UIKit

class OnboardConsultationViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var durationField: UITextField!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var buttonImage: UIImageView!
    
    var phone = ""
    var entityID : Int?
    var doctorID : Int?
    var departmentID: Int?
    var doctorName : String?
    var workingHours : [WorkingHour] = []
    
    let viewModel = GeneralViewModel()
    var onboardData: OnboardResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSuffix()
        self.setupAction()
        self.disableSignIn()
        self.durationField.delegate = self
        self.mainView.layer.cornerRadius = 10
        self.buttonImage.layer.cornerRadius = 10
        self.durationField.layer.cornerRadius = 10
        self.durationField.layer.borderWidth = 1
        self.durationField.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func regsiterAction() {
        let consultTime = self.durationField.text ?? ""
        if (Int(consultTime) ?? 0) > 60 {
            self.durationField.text = ""
            Utility.showMessage(message: "Enter a valid consultation time.", controller: self)
            self.disableSignIn()
        }
        else {
            let doctorDetails = DoctorDetails(doctorPhone: phone, doctorName: doctorName, departmentID: departmentID, consultationTime: Int(durationField.text ?? "0"), entityID: entityID, doctorID: doctorID, workingHours: workingHours)
            print("doctor details: \(doctorDetails)")
            self.viewModel.onboardDoctor(data: doctorDetails) { result in
                switch result {
                case .success(let success):
                    self.onboardData = success
                    switch self.onboardData?.statusCode {
                        
                    case 200:
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessOnboardViewController") as? SuccessOnboardViewController else { return }
                        if let data = self.onboardData?.data {
                            UserDefaults.standard.set(data.accessToken, forKey: "accessToken")
                            UserDefaults.standard.set(data.refreshToken, forKey: "refreshToken")
                            UserDefaults.standard.set(data.doctorID, forKey: "doctorID")
                            UserDefaults.standard.set(data.entityID, forKey: "entityID")
                            UserDefaults.standard.set(data.phone, forKey: "phone")
                            //UserDefaults.standard.set(true, forKey: "loginStatus")
                        }
                        self.navigationController?.pushViewController(vc, animated: false)
                    default:
                        Utility.showMessage(message: self.onboardData?.message ?? "", controller: self)
                    }
                case .failure(let failure):
                    Utility.showMessage(message: failure.localizedDescription, controller: self)
                }
            }
        }
    }
    
    func setSuffix() {
        let label = UILabel()
        label.text = "  min   "
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.sizeToFit()
        self.durationField.rightView = label
        self.durationField.rightViewMode = .always
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

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

extension OnboardConsultationViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        guard characterSet.isSubset(of: allowedCharacters) else {
            return false
        }
        
        let maxLength = 2
        let currentString: NSString = (self.durationField.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        let strLength = newString.length
        
        if strLength > 2 {
            DispatchQueue.main.async {
                self.durationField.endEditing(true)
                self.disableSignIn()
            }
        }
        else {
            self.enableSignIn()
        }
        return (newString.length) <= (maxLength)
    }
}
