//
//  OnboardDaysViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import UIKit

class OnboardDaysViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var monView: UIView!
    @IBOutlet weak var tueView: UIView!
    @IBOutlet weak var wedView: UIView!
    @IBOutlet weak var thurView: UIView!
    @IBOutlet weak var friView: UIView!
    @IBOutlet weak var satView: UIView!
    @IBOutlet weak var sunView: UIView!
    
    var phone = ""
    var isSelected = Bool()
    var entityID : Int?
    var doctorID : Int?
    var departmentID: Int?
    var doctorName : String?
    var days : [String] = []
    var dayViews : [UIView] = []
    
    let dayMapping: [String: String] = [
        "Mon": "Monday",
        "Tue": "Tuesday",
        "Wed": "Wednesday",
        "Thu": "Thursday",
        "Fri": "Friday",
        "Sat": "Saturday",
        "Sun": "Sunday"
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAction()
        self.disableSignIn()
        self.mainView.layer.cornerRadius = 10
        self.buttonImage.layer.cornerRadius = 10
        
        self.dayViews = [self.monView, self.tueView, self.wedView, self.thurView, self.friView, self.satView, self.sunView]
        
        for i in self.dayViews {
            i.backgroundColor = .appGray
            i.layer.cornerRadius = 10
            self.addTapGesture(to: i)
        }
    }
    
    @objc func regsiterAction() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardSessionViewController") as? OnboardSessionViewController else { return }
        vc.phone = phone
        vc.entityID = entityID
        vc.doctorID = doctorID
        vc.doctorName = doctorName
        vc.departmentID = departmentID
        vc.days = days
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }

        if tappedView.backgroundColor == UIColor.appGray {
            tappedView.backgroundColor = UIColor.appTheme
        }
        else {
            tappedView.backgroundColor = UIColor.appGray
        }
        
        if let label = tappedView.subviews.first(where: { $0 is UILabel }) as? UILabel {
            if tappedView.backgroundColor == UIColor.appTheme {
                if let fullDayName = self.dayMapping[label.text ?? ""] {
                    self.days.append(fullDayName)
                }
                if self.days.count > 0 {
                    self.enableSignIn()
                }
            }
            else {
                if let fullDayName = self.dayMapping[label.text ?? ""], let index = self.days.firstIndex(of: fullDayName) {
                    self.days.remove(at: index)
                }
            }
        }
        
        if self.days.count == 0 {
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
    
    func addTapGesture(to view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    
    func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.regsiterAction))
        self.signInView.addGestureRecognizer(tap)
        self.signInView.isUserInteractionEnabled = true
    }
            
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}
