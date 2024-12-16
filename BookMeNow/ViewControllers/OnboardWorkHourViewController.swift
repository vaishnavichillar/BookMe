//
//  OnboardWorkHourViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import UIKit

class OnboardWorkHourViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mrngStartView: UIView!
    @IBOutlet weak var mrngEndView: UIView!
    @IBOutlet weak var evngStartView: UIView!
    @IBOutlet weak var evngEndView: UIView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var signInView: UIView!
    
    @IBOutlet weak var mrngStartButton: UIButton!
    @IBOutlet weak var mrngEndButton: UIButton!
    @IBOutlet weak var evngStartButton: UIButton!
    @IBOutlet weak var evngEndButton: UIButton!
    
    @IBOutlet weak var mrngStartTime: UILabel!
    @IBOutlet weak var mrngEndTime: UILabel!
    @IBOutlet weak var evngStartTime: UILabel!
    @IBOutlet weak var evngEndTime: UILabel!
    
    @IBOutlet weak var morningStack: UIStackView!
    @IBOutlet weak var eveningStack: UIStackView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var phone = ""
    var entityID : Int?
    var doctorID : Int?
    var departmentID: Int?
    var doctorName : String?
    var days : [String] = []
    var sessionType : Int?
    var selectedButton: String?
    var workingHours : [WorkingHour] = []
    var sessionViews : [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAction()
        self.datePickerView.isHidden = true
        self.mainView.layer.cornerRadius = 10
        self.buttonImage.layer.cornerRadius = 10
        
        self.mrngStartButton.showsMenuAsPrimaryAction = true
        self.mrngEndButton.showsMenuAsPrimaryAction = true
        self.evngStartButton.showsMenuAsPrimaryAction = true
        self.evngEndButton.showsMenuAsPrimaryAction = true
        self.sessionViews = [self.mrngStartView, self.mrngEndView, self.evngStartView, self.evngEndView ]
        
        switch self.sessionType {
        case 0:
            self.morningStack.isHidden = false
            self.eveningStack.isHidden = true
        case 1:
            self.morningStack.isHidden = true
            self.eveningStack.isHidden = false
        case 2:
            self.morningStack.isHidden = false
            self.eveningStack.isHidden = false
        default:
            self.morningStack.isHidden = false
            self.eveningStack.isHidden = true
        }

        for i in self.sessionViews {
            i.layer.cornerRadius = 10
            i.layer.borderWidth = 1
            i.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @objc func regsiterAction() {
        if self.sessionType == 0 {
            for i in self.days {
               let workHour = WorkingHour(day: i,
                                          startTime: self.mrngStartTime.text,
                                          endTime: self.mrngEndTime.text,
                                          session: "morning")
                self.workingHours.append(workHour)
            }
        }
        
        if self.sessionType == 1 {
            for i in self.days {
               let workHour = WorkingHour(day: i,
                                          startTime: self.evngStartTime.text,
                                          endTime: self.evngEndTime.text,
                                          session: "evening")
                self.workingHours.append(workHour)
            }
        }
        
        if self.sessionType == 2 {
            for i in self.days {
               let workHour1 = WorkingHour(day: i,
                                           startTime: self.mrngStartTime.text,
                                           endTime: self.mrngEndTime.text,
                                           session: "morning")
                self.workingHours.append(workHour1)
            }
            
            for i in self.days {
               let workHour2 = WorkingHour(day: i,
                                           startTime: self.evngStartTime.text,
                                           endTime: self.evngEndTime.text,
                                           session: "evening")
                self.workingHours.append(workHour2)
            }
        }
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardConsultationViewController") as? OnboardConsultationViewController else { return }
        vc.phone = phone
        vc.entityID = entityID
        vc.doctorID = doctorID
        vc.doctorName = doctorName
        vc.departmentID = departmentID
        vc.workingHours = workingHours
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.regsiterAction))
        self.signInView.addGestureRecognizer(tap)
        self.signInView.isUserInteractionEnabled = true
    }
    
    @IBAction func mrngStartSession(_ sender: UIButton) {
        self.selectedButton = "mrngStart"
        self.datePickerView.isHidden = false
    }
    
    @IBAction func mrngEndSession(_ sender: Any) {
        self.selectedButton = "mrngEnd"
        self.datePickerView.isHidden = false
    }
    
    @IBAction func evngStartSession(_ sender: Any) {
        self.selectedButton = "evngStart"
        self.datePickerView.isHidden = false
    }
    
    @IBAction func evngEndSession(_ sender: Any) {
        self.selectedButton = "evngEnd"
        self.datePickerView.isHidden = false
    }
    
    @IBAction func didCancelBtnTap(_ sender: Any) {
        self.datePickerView.isHidden = true
    }
    
    @IBAction func didDoneBtnTap(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let selectedTime = formatter.string(from: self.datePicker.date)

        switch selectedButton {
        case "mrngStart":
            self.mrngStartTime.text = selectedTime
            self.datePickerView.isHidden = true
        case "mrngEnd":
            self.mrngEndTime.text = selectedTime
            self.datePickerView.isHidden = true
        case "evngStart":
            self.evngStartTime.text = selectedTime
            self.datePickerView.isHidden = true
        case "evngEnd":
            self.evngEndTime.text = selectedTime
            self.datePickerView.isHidden = true
        default:
            break
        }

        self.datePickerView.isHidden = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}
