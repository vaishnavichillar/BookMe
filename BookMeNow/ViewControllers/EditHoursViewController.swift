//
//  EditHoursViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 15/10/24.
//

import UIKit

class EditHoursViewController: UIViewController {
    
    @IBOutlet weak var editHoursTableview: UITableView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var datePickedView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isStartTime = false
    var selectedIndexPath: IndexPath?
    
    let apiManager = APIManager()
    var workData : WorkingHoursModel?
    
    let entityId = UserDefaults.standard.integer(forKey: "entityID")
    var doctorID = UserDefaults.standard.integer(forKey: "doctorID")
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.isHidden = true
        self.datePickedView.isHidden = true
        self.getWorkHours()
        /*mySwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.editHoursTableview.reloadData()*/
    }
    
    @IBAction func didCancelBtnTap(_ sender: Any) {
        self.datePickedView.isHidden = true
    }
    
    @IBAction func didDoneBtnTap(_ sender: Any) {
        let selectedTime = self.datePicker.date.toString() // No need for optional binding
        if isStartTime {
            // Set start time
            if let indexPath = selectedIndexPath {
                let cell = editHoursTableview.cellForRow(at: indexPath) as! editHoursTableviewcell
                cell.startLabel.text = selectedTime
            }
        }
        else {
            // Set end time
            if let indexPath = selectedIndexPath {
                let cell = editHoursTableview.cellForRow(at: indexPath) as! editHoursTableviewcell
                cell.endLabel.text = selectedTime
            }
        }
        self.datePickedView.isHidden = true
    }
    
    @IBAction func didBackBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getWorkHours() {
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
        self.apiManager.getWorkingHours(doctorID: "\(self.doctorID ?? 0)", entityID: "\(self.entityId ?? 0)",  token: self.accessToken) { response in
            switch response {
            case .success(let success):
                self.indicatorView.isHidden = true
                self.indicator.stopAnimating()
                self.workData = success
                let statusCode = self.workData?.statusCode
                switch statusCode {
                    
                case 200:
                    self.editHoursTableview.reloadData()
                case 403:
                    print("Error")
                default:
                    self.indicatorView.isHidden = true
                    self.indicator.stopAnimating()
                    Utility.showMessage(message: self.workData?.message ?? "", controller: self)
                }
            case .failure(let failure):
                self.indicatorView.isHidden = true
                self.indicator.stopAnimating()
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
}

extension EditHoursViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editHoursTableviewcell") as! editHoursTableviewcell
        cell.mainView.borderWidth = 1
        cell.mainView.borderColor = UIColor.darkGray
        cell.mainView.cornerRadius = 10
        cell.eveningMainView.borderWidth = 1
        cell.eveningMainView.borderColor = UIColor.darkGray
        cell.eveningMainView.cornerRadius = 10

        if let workResult = self.workData?.data?.result?[indexPath.row] {
            cell.morningDaysLabel.text = workResult.day
            cell.eveningDaysLabel.text = workResult.day

            let schedules = workResult.workSchedule
            
            // Morning schedule
            if let morningSchedule = schedules?.first(where: { $0.session == "morning" }) {
                /*cell.isSwitch.isEnabled = true
                cell.isSwitch.isOn = true
                cell.isSwitch.onTintColor = UIColor.appTheme*/
                cell.morningView.isHidden = false
                cell.morningDaysLabel.textColor = UIColor.black
                cell.startLabel.text = morningSchedule.startTime ?? "-"
                cell.endLabel.text = morningSchedule.endTime ?? "-"
                cell.startLabel.textColor = UIColor.appTheme
                cell.endLabel.textColor = UIColor.appTheme
                cell.toLabel.textColor = UIColor.appTheme
                cell.morningLabel.text = morningSchedule.session ?? "-"
                cell.morningLabel.textColor = UIColor.black
            }
            else {
                cell.morningView.isHidden = true
            }

            // Evening schedule
            if let eveningSchedule = schedules?.first(where: { $0.session == "evening" }) {
                cell.eveningView.isHidden = false
                cell.eveningDaysLabel.textColor = UIColor.black
                cell.evenStartLabel.text = eveningSchedule.startTime ?? "-"
                cell.evenEndLabel.text = eveningSchedule.endTime ?? "-"
                cell.evenStartLabel.textColor = UIColor.appTheme
                cell.evenEndLabel.textColor = UIColor.appTheme
                cell.eveningLabel.text = eveningSchedule.session ?? "-"
                cell.eveningLabel.textColor = UIColor.black
            }
            else {
                cell.eveningView.isHidden = true
            }
        }
        
        // Morning buttons
        cell.startBtn.tag = indexPath.row
        cell.startBtn.addTarget(self, action: #selector(self.didTapStartBtn(_:)), for: .touchUpInside)
        cell.endBtn.tag = indexPath.row
        cell.endBtn.addTarget(self, action: #selector(self.didTapEndBtn(_:)), for: .touchUpInside)

        // Evening buttons
        cell.evenStartBtn.tag = indexPath.row
        cell.evenStartBtn.addTarget(self, action: #selector(self.didTapEveningStartBtn(_:)), for: .touchUpInside)
        cell.evenEndBtn.tag = indexPath.row
        cell.evenEndBtn.addTarget(self, action: #selector(self.didTapEveningEndBtn(_:)), for: .touchUpInside)

        return cell
    }

    @objc func didTapStartBtn(_ sender: UIButton) {
        self.isStartTime = true
        self.selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        self.datePickedView.isHidden = false
    }
    
    @objc func didTapEndBtn(_ sender: UIButton) {
        self.isStartTime = false
        self.selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        self.datePickedView.isHidden = false
    }
    
    @objc func didTapEveningStartBtn(_ sender: UIButton) {
        self.isStartTime = true
        self.selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        self.datePickedView.isHidden = false
    }

    @objc func didTapEveningEndBtn(_ sender: UIButton) {
        self.isStartTime = false
        self.selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        self.datePickedView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class editHoursTableviewcell: UITableViewCell {
    @IBOutlet weak var morningDaysLabel: UILabel!
    @IBOutlet weak var eveningDaysLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var morningLabel: UILabel!
    @IBOutlet weak var eveningLabel: UILabel!
    @IBOutlet weak var evenStartLabel: UILabel!
    @IBOutlet weak var evenEndLabel: UILabel!
    @IBOutlet weak var evenStartBtn: UIButton!
    @IBOutlet weak var evenEndBtn: UIButton!
    @IBOutlet weak var isSwitch: UISwitch!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var morningView: UIView!
    @IBOutlet weak var eveningView: UIView!
    @IBOutlet weak var eveningMainView: UIView!
    @IBOutlet weak var toLabel: UILabel!
}

/*Switch logic remains the same as your implementation
 cell.isSwitch.tag = indexPath.row
 cell.isSwitch.addTarget(self, action: #selector(self.didTapSwitchBtn(_:)), for: .touchUpInside)
 
 @objc func didTapSwitchBtn(_ sender: UISwitch) {
    
    let indexpath = IndexPath(row: sender.tag, section: 0)
    let cell = self.editHoursTableview.cellForRow(at: indexpath) as! editHoursTableviewcell
    if sender.isOn {
        cell.daysLabel.textColor = UIColor.black
        cell.startLabel.textColor = UIColor.appTheme
        cell.endLabel.textColor = UIColor.appTheme
        cell.toLabel.textColor = UIColor.appTheme
        //cell.isSwitch.onTintColor = UIColor.appTheme
        cell.morningLabel.textColor = UIColor.black
    }
    else {
        cell.daysLabel.textColor = UIColor.lightGray
        cell.startLabel.textColor = UIColor.lightGray
        cell.endLabel.textColor = UIColor.lightGray
        cell.toLabel.textColor = UIColor.lightGray
        //cell.isSwitch.onTintColor = UIColor.lightGray
        cell.morningLabel.textColor = UIColor.lightGray
    }
}*/
