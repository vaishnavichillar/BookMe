//
//  OnboardDoctorNameViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import UIKit

class OnboardDoctorNameViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var nameField: UITextField!
    
    var phone = ""
    var entityID : Int?
    var doctorID : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupAction()
        self.enableSignIn()
        self.disableSignIn()
        self.setPrefix()
    }
    
    @objc func regsiterAction() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardSpecialityViewController") as? OnboardSpecialityViewController else { return }
        vc.phone = phone
        vc.entityID = entityID
        vc.doctorID = doctorID
        vc.doctorName = nameField.text
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func setup() {
        self.mainView.layer.cornerRadius = 10
        self.buttonImage.layer.cornerRadius = 10
        self.nameField.delegate = self
        self.nameField.layer.borderWidth = 1
        self.nameField.layer.borderColor = UIColor.black.cgColor
        self.nameField.layer.cornerRadius = 10
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
    
    func setPrefix() {
        let label = UILabel()
        label.text = " Dr. "
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.sizeToFit()
        self.nameField.leftView = label
        self.nameField.leftViewMode = .always
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

extension OnboardDoctorNameViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        let allowedCharacters = CharacterSet.letters.union(.whitespaces)
        let characterSet = CharacterSet(charactersIn: string)
        let isAlphabet = allowedCharacters.isSuperset(of: characterSet)
        let currentText = self.nameField.text ?? ""
        let updatedTextLength = currentText.count + string.count - range.length
        if updatedTextLength > maxLength {
            return false
        }
        
        if updatedTextLength > 3 {
            self.enableSignIn()
        }
        else {
            self.disableSignIn()
        }
        return isAlphabet
    }
}
