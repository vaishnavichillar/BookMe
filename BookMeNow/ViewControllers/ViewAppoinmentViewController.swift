//
//  ViewAppoinmentViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 07/02/24.
//

import UIKit

class ViewAppoinmentViewController: UIViewController {

    @IBOutlet weak var appoinmentView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var totalPatients: UILabel!
    @IBOutlet weak var completed: UILabel!
    @IBOutlet weak var pending: UILabel!
    @IBOutlet weak var bookingsTable: UITableView!
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var chooseDate: UIImageView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var topView: UIImageView!
    
    var selectedDate: String?
    var overlayView : UIView!
    
    var updatedData: BookingUpdateModel?
    var apiManager = APIManager()
    var homeModel : HomeModel?
    var smartPopup : SmartPopUp?
    let helper = Helper()
    
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    let doctorID = UserDefaults.standard.integer(forKey: "doctorID")
    var entityID = UserDefaults.standard.integer(forKey: "entityID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.helper.ViewModification(myView: topView, mycorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], myCornerRadius: 15)
        bookingsTable.delegate = self
        bookingsTable.dataSource = self
        bookingsTable.register(UINib(nibName: "BookingsTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingsTableViewCell")
        self.setup()
        self.setDate()
        self.showAppoinments(doctorID: doctorID, date: selectedDate!)
        self.bookingsTable.showsVerticalScrollIndicator = false
        self.overlayView = UIView(frame: view.bounds)
        self.overlayView.backgroundColor = .clear
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.overlayView.addGestureRecognizer(tapGestureRecognizer)
        
        let chooseDateRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseDate(_:)))
        self.chooseDate.isUserInteractionEnabled = true
        self.chooseDate.addGestureRecognizer(chooseDateRecognizer)
    }
    
    @objc func chooseDate(_ sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.callback = { data in
            self.selectedDate = data
            self.setDate()
            self.showAppoinments(doctorID: self.doctorID, date: self.selectedDate!)
        }
        navigationController?.present(vc, animated: false)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.smartPopup?.removeFromSuperview()
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
        }
        self.overlayView.removeFromSuperview()
    }
    
    @objc func completedAction() {
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
        }
        /*let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScanAndPayViewController") as! ScanAndPayViewController
        vc.doctorName = homeModel?.data?.doctorName
        vc.bookingID = smartPopup?.bookingID
        self.navigationController?.pushViewController(vc, animated: false)*/
        let alert = UIAlertController(title: "Complete Booking", message: "Do you want to complete the booking?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { _ in
            if let bookingID = self.smartPopup?.bookingID {
                self.getBookingUpdate(bookingID: bookingID, token: self.accessToken)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(cancelAction)
        alert.addAction(action)
        navigationController?.present(alert, animated: true)
    }
    
    @objc func startCallAction() {
        guard let phoneURL = URL(string: "tel://\(smartPopup?.mobileNumber ?? "")"), UIApplication.shared.canOpenURL(phoneURL) else { return }
        UIApplication.shared.open(phoneURL, options: [:]) { _ in
            UIView.animate(withDuration: 0.3) {
                self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
            }
        }
    }
    
    func setup() {
        self.appoinmentView.layer.cornerRadius = 10
        self.appoinmentView.layer.shadowColor = UIColor.black.cgColor
        self.appoinmentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.appoinmentView.layer.shadowOpacity = 0.5
        self.appoinmentView.layer.shadowRadius = 8
    }
    
    func startIndicator() {
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
    }
    
    func stopIndicator() {
        self.indicatorView.isHidden = true
        self.indicator.stopAnimating()
    }
    
    func showAppoinments(doctorID: Int, date: String) {
        self.startIndicator()
        self.apiManager.getHomeData(doctorId: doctorID, date: date, entityID: entityID, token: self.accessToken) { response in
            switch response {
            case .success(let success):
                let statusCode = success.statusCode

                switch statusCode {
                case 200:
                    self.stopIndicator()
                    self.homeModel = success
                    self.totalPatients.text = "\(self.homeModel?.data?.totalBooking ?? 0)"
                    self.completed.text = "\(self.homeModel?.data?.completedAppointments ?? 0)"
                    self.pending.text = "\(self.homeModel?.data?.pendingAppointments ?? 0)"
                    if self.homeModel?.data?.appointmentList?.count == 0 {
                        self.noDataImage.isHidden = false
                        self.noDataLabel.isHidden = false
                    }
                    else {
                        self.noDataImage.isHidden = true
                        self.noDataLabel.isHidden = true
                    }
                    self.bookingsTable.reloadData()
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken) { flag, _, _ in
                        switch flag {
                        case true:
                            self.showAppoinments(doctorID: doctorID, date: date)
                        case false:
                            print("Error generating token")
                        }
                    }
                default:
                    self.stopIndicator()
                    Utility.showMessage(message: success.message, controller: self)
                }
            case .failure(let failure):
                self.stopIndicator()
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }

    func setDate() {
        let dateString = selectedDate ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE" // Get the day name (e.g., Monday)
            
            let monthDayFormatter = DateFormatter()
            monthDayFormatter.dateFormat = "d" // Get the day of the month without leading zeros (e.g., 12)
            
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy" // Get the year (e.g., 2024)
            
            let monthnameFormatter = DateFormatter()
            monthnameFormatter.dateFormat = "MMM"
            
            let dayName = dayFormatter.string(from: date)
            let monthDay = monthDayFormatter.string(from: date)
            let year = yearFormatter.string(from: date)
            let month = monthnameFormatter.string(from: date)
            
            self.dayLabel.text = "\(dayName)"
            self.dateLabel.text = "\(monthDay)"
            self.yearLabel.text = "\(month) \(year)"
            
            let formattedDate = "\(dayName) \(monthDay) \(year)"
            print(formattedDate) // Output: Monday 12 2024
        }
        else {
            print("Invalid date format")
        }
    }
    
    func smartPopup(popTitle: String, popMessage: String, fTitle: String, stitle: String) {
        let frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 180, width: UIScreen.main.bounds.width, height: 180)
        self.smartPopup = SmartPopUp(frame: frame)
        self.smartPopup?.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        self.smartPopup?.popupTitle.text = popTitle
        self.smartPopup?.popupMessage.text = popMessage
        self.smartPopup?.firstButton.setTitle(fTitle, for: .normal)
        self.smartPopup?.secondButton.setTitle(stitle, for: .normal)

        self.smartPopup?.firstButton.addTarget(self, action: #selector(startCallAction), for: .touchUpInside)
        self.smartPopup?.secondButton.addTarget(self, action: #selector(completedAction), for: .touchUpInside)
        view.addSubview(overlayView)
        self.view.addSubview(smartPopup ?? UIView())
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height - (self.smartPopup?.frame.height ?? 0)
        }
    }
    
    func getBookingUpdate(bookingID : Int, token: String) {
        self.startIndicator()
        self.apiManager.getBookingUpdateStatus(bookingID: bookingID, token: self.accessToken) { response in
            switch response {
            case .success(let success):
                self.updatedData = success
                let statusCode = self.updatedData?.statusCode
                self.stopIndicator()
                
                switch statusCode {
                case 200:
                    self.showAppoinments(doctorID: self.doctorID, date: self.selectedDate!)
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken)  { flag, _, _ in
                    switch flag {
                    case true:
                        self.getBookingUpdate(bookingID: bookingID, token: token)
                    case false:
                        print("Error generating token")
                    }
                }
                default:
                    self.stopIndicator()
                    self.helper.generateAccessToken(token: self.refreshToken) { flag,response, _  in
                        switch flag {
                        case true:
                            let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
                            self.getBookingUpdate(bookingID: bookingID, token: accessToken)
                        case false:
                            print("Error while regenrating token")
                        }
                    }
                }
            case .failure(let failure):
                self.stopIndicator()
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

extension ViewAppoinmentViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeModel?.data?.appointmentList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsTableViewCell", for: indexPath) as? BookingsTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let data = self.homeModel?.data?.appointmentList {
            cell.configure(with: data[indexPath.row])
            /*if data[indexPath.row].bookingStatus == 1 {
                cell.callButton.isHidden = true
               
            } else {
                cell.callButton.isHidden = false
               
            }*/
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedData = homeModel?.data?.appointmentList?[indexPath.row] {
            self.smartPopup(popTitle: "Booking Information", popMessage: "Patient Name : \(selectedData.customerName ?? "")", fTitle: "START A CALL", stitle: "COMPLETE")
            self.smartPopup?.bookingID = selectedData.bookingID
            self.smartPopup?.mobileNumber = selectedData.customerPhone
            if selectedData.bookingStatus == 1 {
                self.smartPopup?.firstButton.isHidden = true
                self.smartPopup?.secondButton.isHidden = true
                self.smartPopup?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 120, width: view.bounds.width, height: 120)
            }
            else {
                self.smartPopup?.firstButton.isHidden = false
                self.smartPopup?.secondButton.isHidden = false
            }
        }
    }
}
