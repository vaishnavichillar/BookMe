//
//  HomeViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 03/02/24.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var appoinmentView: UIView!
    @IBOutlet weak var weekDayName: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var numberOfAppoinments: UILabel!
    @IBOutlet weak var completedAppoinments: UILabel!
    @IBOutlet weak var pendingAppoinments: UILabel!
    @IBOutlet weak var appoinmenttable: UITableView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var menuView: UIStackView!
    @IBOutlet weak var versionNumber: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var addLeaveButton: UIView!
    @IBOutlet weak var hourStack: UIStackView!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var shareLinkView: UIView!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var refundView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var topView: UIImageView!
    @IBOutlet weak var editDateView: UIView!
    
    var bookingLink = ""
    var isLogoutPopup = false
    var isViewVisible = false
    
    let date = Date()
    var entityID : Int?
    var bookingDate : String?
    var overlayView : UIView!
    
    var accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    var refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    var doctorID = UserDefaults.standard.integer(forKey: "doctorID")
    let version = UserDefaults.standard.string(forKey: "versionNumber") ?? ""
    var phone = UserDefaults.standard.string(forKey: "phone") ?? ""
    
    let helper = Helper()
    var smartPopup : SmartPopUp?
    let viewModel = HomeViewModel()
    var apiManager = APIManager()
    var homeModel : HomeModel?
    var otpData : VerifyUserModel?
    var bookingModel : BookingLinkModel?
    var updatedData: BookingUpdateModel?
    var welcomeData: WelcomeModel?
    
    var termsUrl = "https://www.chillarpayments.com/terms-and-conditions.html"
    var privacyUrl = "https://www.chillarpayments.com/privacy-policy.html"
    var refundUrl = "https://www.chillarpayments.com/Cancellation-Policy.html"
    var contactUrl = "https://www.chillarpayments.com/contactus.html"
    var aboutUrl = "https://www.chillarpayments.com/privatepractice.html"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = "Private Practice"
        self.versionNumber.text = "Version : \(version)"
        self.appoinmenttable.delegate = self
        self.appoinmenttable.dataSource = self
        self.menuView.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.appoinmenttable.showsVerticalScrollIndicator = false
        self.setup()
        self.setupAction()
        self.addUserInteraction()
        self.bookingDate = helper.formatDate(date: date)
        self.appoinmenttable.register(UINib(nibName: "BookingsTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingsTableViewCell")
        /*collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(UINib(nibName: "ClinicsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ClinicsCollectionViewCell")*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiManager.verifyUser(phone: phone) { result in
         switch result {
             case .success(let success):
                 print(success)
                 self.otpData = success
                 UserDefaults.standard.set(self.otpData?.data?.refreshToken, forKey: "refreshToken")
                 UserDefaults.standard.set(self.otpData?.data?.accessToken, forKey: "accessToken")
                 UserDefaults.standard.synchronize()
                 self.getHomeData(entityID: self.entityID, accessToken: self.otpData?.data?.accessToken ?? "")
                 self.getWelcomeData()
             case .failure(let failure):
                 self.indicator.stopAnimating()
                 self.indicatorView.isHidden = true
                 Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
             }
         }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !self.menuView.isHidden {
            self.menuView.isHidden = true
        }
    }
    
    @objc func termsTapped() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else { return }
        vc.url = termsUrl
        vc.headerTitle = "Terms & Conditions"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func privacyTapped() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else { return }
        vc.url = privacyUrl
        vc.headerTitle = "Privacy Policy"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func refundTapped() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else { return }
        vc.url = refundUrl
        vc.headerTitle = "Refund"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func contactTapped() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else { return }
        vc.url = contactUrl
        vc.headerTitle = "Contact Us"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func aboutTapped() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else { return }
        vc.url = aboutUrl
        vc.headerTitle = "About"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleMenuTap(_ sender: UITapGestureRecognizer) {
        if !self.menuView.isHidden {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1) {
                    self.menuView.isHidden = true
                }
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
        }
        self.overlayView.removeFromSuperview()
    }
    
    @objc func homeViewTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        vc?.modalTransitionStyle = .coverVertical
        self.navigationController?.pushViewController(vc!, animated: false)
    }

    @objc func profileViewTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        vc?.modalTransitionStyle = .coverVertical
        vc?.navigatingFrom = "Settings"
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    @objc func reportViewTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportViewController")
        vc.modalTransitionStyle = .coverVertical
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func settingsViewTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        vc?.modalTransitionStyle = .coverVertical
        vc?.navigatingFrom = "Settings"
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    @objc func logoutViewTapped() {
        self.isLogoutPopup = true
        self.smartPopup(popTitle: "Logout", popMessage: "Are you sure you want to logout?", fTitle: "LOGOUT", stitle: "CANCEL")
    }
    
    @objc func calendarViewTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        vc.fromReportPage = false
        vc.callback = { data in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAppoinmentViewController") as! ViewAppoinmentViewController
            vc.selectedDate = data
            self.navigationController?.pushViewController(vc, animated: false)
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    @objc func shareButton() {
        self.getBookingLink()
    }
    
    @objc func addLeaveAction() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController else { return }
        vc.addLeave = true
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: false)
    }
    
    @objc func editTimeAction() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditHoursViewController") as? EditHoursViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logoutAction() {
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
        }
        self.viewModel.logoutUser() { success in
            if success {
                UserDefaults.standard.set(false, forKey: "loginStatus")
                UserDefaults.standard.set("", forKey: "refreshToken")
                UserDefaults.standard.set("", forKey: "accessToken")
                UserDefaults.standard.set(nil, forKey: "SelectedIndex")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashViewController")
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    @objc func cancelAction() {
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
        }
    }
    
    @objc func startCallAction() {
        guard let phoneURL = URL(string: "tel://\(smartPopup?.mobileNumber ?? "")"), UIApplication.shared.canOpenURL(phoneURL) else
        { return }
        UIApplication.shared.open(phoneURL, options: [:]) { _ in
            UIView.animate(withDuration: 0.3) {
                self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
            }
        }
    }
    
    @objc func completedAction() {
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
        }
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
    
    func startIndicator() {
        self.indicator.startAnimating()
        self.indicatorView.isHidden = false
    }
    
    func stopIndicator() {
        self.indicator.stopAnimating()
        self.indicatorView.isHidden = true
    }
    
    func setup() {
        Helper.helper.ViewModification(myView: topView, mycorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], myCornerRadius: 15)
        self.overlayView = UIView(frame: view.bounds)
        self.overlayView.backgroundColor = .clear
        
        self.hourStack.layer.cornerRadius = 10
        self.hourStack.layer.borderWidth = 1
        self.hourStack.layer.borderColor = UIColor.appTheme.cgColor
        
        self.editDateView.layer.borderWidth = 0.5
        self.editDateView.layer.borderColor = UIColor.appTheme.cgColor
        
        self.addLeaveButton.layer.borderWidth = 0.5
        self.addLeaveButton.layer.borderColor = UIColor.appTheme.cgColor
        
        self.calendarView.layer.cornerRadius = 10
        self.appoinmentView.layer.cornerRadius = 10
        self.shareImage.layer.cornerRadius = 10
        
        self.appoinmentView.layer.shadowColor = UIColor.black.cgColor
        self.appoinmentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.appoinmentView.layer.shadowOpacity = 0.5
        self.appoinmentView.layer.shadowRadius = 8
        
        self.profileView.isUserInteractionEnabled = true
    }
    
    func getWelcomeData() {
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
        
        self.apiManager.getWelcomeData(token: self.otpData?.data?.accessToken ?? "") { response in
            switch response {
            case .success(let success):
                let statusCode = success.statusCode
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                
                switch statusCode {
                    
                case 200:
                    self.welcomeData = success
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken)
                case 422:
                    Utility.showMessage(message: success.message, controller: self)
                    print("Profile not completed")
                default:
                    Utility.showMessage(message: success.message, controller: self)
                }
            case .failure(let failure):
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
    
    func setupAction() {
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        overlayView.addGestureRecognizer(tapGestureRecognizer)
        
        let termsGesture = UITapGestureRecognizer(target: self, action: #selector(termsTapped))
        termsView.addGestureRecognizer(termsGesture)
        termsView.isUserInteractionEnabled = true
        
        let privacyGesture = UITapGestureRecognizer(target: self, action: #selector(privacyTapped))
        privacyView.addGestureRecognizer(privacyGesture)
        privacyView.isUserInteractionEnabled = true
        
        let refundGesture = UITapGestureRecognizer(target: self, action: #selector(refundTapped))
        refundView.addGestureRecognizer(refundGesture)
        refundView.isUserInteractionEnabled = true
        
        let contactGesture = UITapGestureRecognizer(target: self, action: #selector(contactTapped))
        contactView.addGestureRecognizer(contactGesture)
        contactView.isUserInteractionEnabled = true
        
        let aboutGesture = UITapGestureRecognizer(target: self, action: #selector(aboutTapped))
        aboutView.addGestureRecognizer(aboutGesture)
        aboutView.isUserInteractionEnabled = true
        
        let menuTap = UITapGestureRecognizer(target: self, action: #selector(handleMenuTap(_:)))
        menuTap.cancelsTouchesInView = false
        view.addGestureRecognizer(menuTap)
        
        let leaveTap = UITapGestureRecognizer(target: self, action: #selector(addLeaveAction))
        addLeaveButton.addGestureRecognizer(leaveTap)
        addLeaveButton.isUserInteractionEnabled = true
        
        let editTimeTap = UITapGestureRecognizer(target: self, action: #selector(editTimeAction))
        editDateView.addGestureRecognizer(editTimeTap)
        editDateView.isUserInteractionEnabled = true
        
        let shareTap = UITapGestureRecognizer(target: self, action: #selector(shareButton))
        shareLinkView.addGestureRecognizer(shareTap)
        shareLinkView.isUserInteractionEnabled = true
    }
    
    func getHomeData(entityID: Int?, accessToken: String) {
        self.startIndicator()
        print("The doctorid is \(doctorID) & \(bookingDate ?? "") & \(entityID ?? 0) & \(accessToken)")
        apiManager.getHomeData(doctorId: doctorID, date: bookingDate ?? "" , entityID: entityID, token: accessToken) { response in
            switch response {
            case .success(let success):
                self.homeModel = success
                let statusCode = success.statusCode ?? 0
                
                switch statusCode {
                case 200:
                    self.stopIndicator()
                    self.setHomeView()
                    self.doctorName.text = "Dr \(self.homeModel?.data?.doctorName ?? "")"
                    self.numberOfAppoinments.text = "\(self.homeModel?.data?.totalBooking ?? 0)"
                    self.completedAppoinments.text = "\(self.homeModel?.data?.completedAppointments ?? 0)"
                    self.pendingAppoinments.text = "\(self.homeModel?.data?.pendingAppointments ?? 0)"
                    self.appoinmenttable.reloadData()
                    //self.collectionview.reloadData()
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken)
                default:
                    self.stopIndicator()
                    Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
                }
            case .failure(let failure):
                self.stopIndicator()
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
    
    func getDayAbbreviation(from date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    func setHomeView() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .day, .day], from: self.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let shortMonthName = dateFormatter.string(from: self.date)
        
        self.weekDayName.text = getDayAbbreviation(from: self.date)
        self.datelabel.text = "\(components.day ?? 0)"
        self.yearLabel.text = "\(shortMonthName) \(components.year ?? 0)"
    }
    
    func addUserInteraction() {
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        profileView.addGestureRecognizer(profileTapGesture)
        /*let reportTapGesture = UITapGestureRecognizer(target: self, action: #selector(reportViewTapped))
        reportView.addGestureRecognizer(reportTapGesture)*/
        let settingsTapGesture = UITapGestureRecognizer(target: self, action: #selector(settingsViewTapped))
        settingsView.addGestureRecognizer(settingsTapGesture)
        let logoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutViewTapped))
        logoutView.addGestureRecognizer(logoutTapGesture)
        let calendarTapGesture = UITapGestureRecognizer(target: self, action: #selector(calendarViewTapped))
        calendarView.addGestureRecognizer(calendarTapGesture)
        let homeTapGesture = UITapGestureRecognizer(target: self, action: #selector(homeViewTapped))
        homeView.addGestureRecognizer(homeTapGesture)
    }
    
    func smartPopup(popTitle: String, popMessage: String, fTitle: String, stitle: String) {
        let frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 180, width: UIScreen.main.bounds.width, height: 180)
        self.smartPopup = SmartPopUp(frame: frame)
        self.smartPopup?.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        self.smartPopup?.popupTitle.text = popTitle
        self.smartPopup?.popupMessage.text = popMessage
        self.smartPopup?.firstButton.setTitle(fTitle, for: .normal)
        self.smartPopup?.secondButton.setTitle(stitle, for: .normal)
        if self.isLogoutPopup {
            self.smartPopup?.secondButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            self.smartPopup?.firstButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        }
        else {
            self.smartPopup?.firstButton.addTarget(self, action: #selector(startCallAction), for: .touchUpInside)
            self.smartPopup?.secondButton.addTarget(self, action: #selector(completedAction), for: .touchUpInside)
        }
        view.addSubview(self.overlayView)
        self.view.addSubview(self.smartPopup ?? UIView())
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height - (self.smartPopup?.frame.height ?? 0)
            self.view.layoutIfNeeded()
        }
    }
    
    func getBookingLink()  {
        self.startIndicator()
        self.apiManager.getBookingLink(token: self.accessToken) { result in
            switch result {
            case .success(let success):
                self.bookingModel = success
                
                switch self.bookingModel?.statusCode {
                case 200:
                    self.stopIndicator()
                    if let data = self.bookingModel {
                        self.bookingLink = data.data ?? ""
                        guard let url = URL(string: self.bookingLink) else {
                            print("Error: Invalid URL string provided.")
                            return
                        }
                        print("The share booking url is \(url)")
                        let urlToShare = [url]
                        let activityViewController = UIActivityViewController(activityItems: urlToShare, applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                        self.navigationController?.present(activityViewController, animated: true, completion: nil)
                    }
                case 400, 403 :
                    self.helper.generateAccessToken(token: self.refreshToken) { flag, response, _ in
                        switch flag {
                        case true:
                            self.getBookingLink()
                        case false:
                            print("Error generating token")
                        }
                    }
                default:
                    self.stopIndicator()
                    Utility.showMessage(message: success.message ?? "", controller: self)
                }
            case .failure(let failure):
                self.stopIndicator()
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }

    func getBookingUpdate(bookingID : Int, token: String) {
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
        }
        self.startIndicator()
        apiManager.getBookingUpdateStatus(bookingID: bookingID, token: self.accessToken) { response in
            switch response {
            case .success(let success):
                self.stopIndicator()
                self.updatedData = success
                let statusCode = self.updatedData?.statusCode
                
                switch statusCode {
                case 200:
                    self.getHomeData(entityID: self.entityID, accessToken: self.accessToken)
                default:
                    self.stopIndicator()
                    self.helper.generateAccessToken(token: self.refreshToken) { flag, response, token in
                        switch flag {
                        case true:
                            self.getBookingUpdate(bookingID: bookingID, token: token ?? "")
                        case false:
                            print("Error generating token")
                        }
                    }
                }
            case .failure(let failure):
                self.stopIndicator()
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
    
    @IBAction func menuAction(_ sender: Any) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                self.menuView.isHidden = !self.menuView.isHidden
            }
        }
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*guard let appointments = homeModel?.data?.appointmentList else { return 0 }
          let filteredAppointments = appointments.filter { $0.bookingStatus == 0 }
          return filteredAppointments.count*/
        guard let appointments = self.homeModel?.data?.appointmentList else { return 0 }
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*if let appointments = homeModel?.data?.appointmentList {
            
            let filteredAppointments = appointments.filter { $0.bookingStatus == 0 }
            
            cell.configure(with: filteredAppointments[indexPath.row])
            if filteredAppointments[indexPath.row].bookingStatus == 1 {
                cell.callButton.isHidden = true
                cell.statusToViewLength.constant = 25
            } else {
                cell.callButton.isHidden = false
                cell.statusToViewLength.constant = 45
            }
        }*/
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsTableViewCell", for: indexPath) as? BookingsTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let appointments = self.homeModel?.data?.appointmentList {
            cell.configure(with: appointments[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isLogoutPopup = false
        if let appointments = self.homeModel?.data?.appointmentList {
            self.smartPopup(popTitle: "Booking Information", popMessage: "Patient Name : \(appointments[indexPath.row].customerName ?? "")", fTitle: "START A CALL", stitle: "COMPLETE")
            self.smartPopup?.bookingID = appointments[indexPath.row].bookingID
            self.smartPopup?.mobileNumber = appointments[indexPath.row].customerPhone
            if appointments[indexPath.row].bookingStatus == 1 {
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

extension HomeViewController : SelectClinicDelegate {
    func selectClinic(cell: ClinicsCollectionViewCell, index: Int?) {
        getHomeData(entityID: index, accessToken: accessToken)
        collectionview.reloadData()
    }
}

/*extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClinicsCollectionViewCell", for: indexPath) as? ClinicsCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        if let data = self.homeModel?.data {
            cell.fromHome = true
            cell.entitDetailsData = data.entityDetails
            cell.collectionview.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20), height: 100)
    }
}

 }*/
