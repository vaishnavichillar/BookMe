//
//  OnboardSessionViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import UIKit

class OnboardSessionViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var mrngButton: UIImageView!
    @IBOutlet weak var evngButton: UIImageView!
    @IBOutlet weak var bothButton: UIImageView!
    @IBOutlet weak var mrngStack: UIStackView!
    @IBOutlet weak var evngStack: UIStackView!
    @IBOutlet weak var bothStack: UIStackView!
    
    var phone = ""
    var session = ""
    var entityID : Int?
    var doctorID : Int?
    var sessionType : Int?
    var departmentID: Int?
    var doctorName : String?
    var selectedOptionIndex: Int?
    
    var days : [String] = []
    var sessions : [UIStackView] = []
    var buttons : [UIImageView] = []
    var workingHours: [WorkingHour] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAction()
        self.mainView.layer.cornerRadius = 10
        self.buttonImage.layer.cornerRadius = 10
        self.sessions = [self.mrngStack, self.evngStack, self.bothStack]
        self.buttons = [self.mrngButton, self.evngButton, self.bothButton]
        
        for (index, image) in self.buttons.enumerated() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(chooseOption))
            image.isUserInteractionEnabled = true
            image.tag = index
            image.addGestureRecognizer(tap)
        }
        
        if self.selectedOptionIndex == nil {
            self.disableSignIn()
        }
        else {
            self.enableSignIn()
        }
    }
    
    @objc func regsiterAction() {
        if self.selectedOptionIndex == nil {
            Utility.showMessage(message: "Please choose session the for consultation", controller: self)
        }
        else {
            switch self.selectedOptionIndex {
            
            case 0:
                self.session = "morning"
            case 1:
                self.session = "evening"
            default:
                print("invalid")
            }
            
            for i in self.days {
                let workHour = WorkingHour(day: i, session: self.session)
                self.workingHours.append(workHour)
            }
            
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardWorkHourViewController") as? OnboardWorkHourViewController else { return }
            vc.phone = phone
            vc.entityID = entityID
            vc.doctorID = doctorID
            vc.doctorName = doctorName
            vc.departmentID = departmentID
            vc.days = days
            vc.sessionType = selectedOptionIndex
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func chooseOption(_ sender: UITapGestureRecognizer) {
        guard let tappedButton = sender.view as? UIImageView else { return }
        self.selectedOptionIndex = tappedButton.tag
        self.updateOptionImages()
        
        if self.selectedOptionIndex == nil {
           self.disableSignIn()
        }
        else {
           self.enableSignIn()
        }
    }
    
    func enableSignIn() {
        self.signInView.isUserInteractionEnabled = true
        self.signInView.alpha = 1.0
    }
    
    func disableSignIn() {
        self.signInView.isUserInteractionEnabled = false
        self.signInView.alpha = 0.5
    }
    
    func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.regsiterAction))
        self.signInView.addGestureRecognizer(tap)
        self.signInView.isUserInteractionEnabled = true
    }
        
    func updateOptionImages() {
        for (index, optionImage) in self.buttons.enumerated() {
            optionImage.image = index == self.selectedOptionIndex ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}
