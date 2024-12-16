//
//  CalendarViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 07/02/24.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController  {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var addLeave = false
    var markedDates: [Date] = []
    var leaveDates: [String] = []
    let formatter = DateFormatter()
    let currentDate = Date()
    var selectedDate : String?
    var callback: ((String) -> ())?
    var fromReportPage = Bool()
    
    var viewModel = GeneralViewModel()
    var calendar: FSCalendar!
    let helper = Helper()
    
    var doctorID = UserDefaults.standard.integer(forKey: "doctorID")
    var entityID = UserDefaults.standard.integer(forKey: "entityID")
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCalendar()
        self.fetchMarkedDates()
        self.getLeaveDate()
        self.formatter.dateFormat = "yyyy-MM-dd"
    }
    
    private func setupCalendar() {
        self.calendar = FSCalendar(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 350))
        self.calendar.dataSource = self
        self.calendar.delegate = self
        FSCalendar.appearance().placeholderType = .none
        self.calendar.appearance.headerTitleColor = UIColor.black
        self.calendar.appearance.weekdayTextColor = UIColor.lightGray
        view.addSubview(calendar)
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor),  // Center horizontally
            self.calendar.centerYAnchor.constraint(equalTo: view.centerYAnchor),  // Center vertically
            self.calendar.widthAnchor.constraint(equalToConstant: 300),           // Set the width
            self.calendar.heightAnchor.constraint(equalToConstant: 400)           // Set the height
        ])
    }

    private func fetchMarkedDates() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.markedDates = self.leaveDates.compactMap { dateFormatter.date(from: $0) }
        self.calendar.reloadData()
    }
   
    func getLeaveDate() {
        self.viewModel.leaveMarkFunc(doctorID: self.doctorID, entityID: self.entityID, token: self.accessToken) { result in
            switch result {
            case .success(let success):
                switch success.statusCode {
                    
                case 200:
                    self.leaveDates = success.data  // Assign leave dates
                    self.fetchMarkedDates() // Update the marked dates
                    self.calendar.reloadData()  // Refresh calendar view
                case 400:
                    self.helper.presentAlertOnTopViewController(title: "", message: success.message) {
                        self.dismiss(animated: false)
                    }
                default:
                    self.helper.presentAlertOnTopViewController(title: "", message: success.message) {
                        self.dismiss(animated: false)
                    }
                }
            case .failure(let failure):
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
    
    @IBAction func okAction(_ sender: Any) {
        if self.addLeave {
            self.viewModel.updateDoctorAvailability(doctorID: self.doctorID, date: self.selectedDate ?? "", token: self.accessToken) { result in
                switch result {
                case .success(let success):
                    switch success.statusCode {
                        
                    case 200:
                        self.helper.presentAlertOnTopViewController(title: "", message: "Leave added successfully.") {
                            self.dismiss(animated: false)
                        }
                    default:
                        self.helper.presentAlertOnTopViewController(title: "", message: success.message) {
                            self.dismiss(animated: false)
                        }
                    }
                case .failure(let failure):
                    Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
                }
            }
        }
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let selectedDateString = formatter.string(from: Date())
            callback?(selectedDate ?? selectedDateString)
            dismiss(animated: true)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - FSCalendar
extension CalendarViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return self.markedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateString = self.formatter.string(from: date)
        if self.leaveDates.contains(dateString) {
            return UIColor.red  // Mark leave dates in red
        }
        return nil  // Default color for other dates
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDateString = formatter.string(from: date)
        selectedDate = selectedDateString
    }
}

