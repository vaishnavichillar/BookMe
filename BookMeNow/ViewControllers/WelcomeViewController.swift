//
//  WelcomeViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 07/02/24.
//

import UIKit
import Alamofire

class WelcomeViewController: UIViewController, ToggleCellDelegate {

    @IBOutlet weak var welcomeTable: UITableView!
    @IBOutlet weak var bookingStatusLabel: UILabel!
    @IBOutlet weak var workingHoursView: UIView!
    @IBOutlet weak var bankAccountView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var bookingButton: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    
    var bookingLink = ""
    var navigatingFrom = "Welcome"
    
    var overlayView : UIView!
    var switchState = Bool()
    
    var isLogoutPopup = false
    var isViewVisible = false
    
    let helper = Helper()
    var smartPopup : SmartPopUp?
    let apiManager = APIManager()
    var welcomeData: WelcomeModel?
    let viewModel = HomeViewModel()
    var bookingModel : BookingLinkModel?
    var welcomeEntityDetails : WelcomeEntityDetails?
    
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    let index = UserDefaults.standard.integer(forKey: "SelectedIndex")
    
    override func viewWillAppear(_ animated: Bool) {
        self.helper.generateAccessToken(token: refreshToken)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupOverlayView()
        self.getWelcomeData()
        self.workingHoursView.layer.cornerRadius = 10
        self.bankAccountView.layer.cornerRadius = 10
        navigationController?.navigationBar.isHidden = true
        
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
        self.collectionview.register(UINib(nibName: "ClinicsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ClinicsCollectionViewCell")
        
        self.welcomeTable.delegate = self
        self.welcomeTable.dataSource = self
        self.welcomeTable.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        self.welcomeTable.register(UINib(nibName: "ToggleSettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "ToggleSettingsTableViewCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(workHoursTapped))
        self.workingHoursView.addGestureRecognizer(tapGesture)
        let bankTapGesture = UITapGestureRecognizer(target: self, action: #selector(bankAccountTapped))
        self.bankAccountView.addGestureRecognizer(bankTapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
        }
        self.overlayView.removeFromSuperview()
    }

    @objc func workHoursTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WorkingHoursViewController") as? WorkingHoursViewController
        vc?.doctorID = welcomeData?.data?.doctorID
        vc?.entityID = welcomeData?.data?.entityDetails?[0].entityID
        vc?.navigatingFrom = "Welcome"
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func bankAccountTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BankAccountViewController") as? BankAccountViewController
        vc?.navigatingFrom = "Welcome"
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func logoutButtonAction() {
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
        }
        self.viewModel.logoutUser() { success in
            if success {
                UserDefaults.standard.set(false, forKey: "loginStatus")
                UserDefaults.standard.set("", forKey: "refreshToken")
                UserDefaults.standard.set("", forKey: "accessToken")
                UserDefaults.standard.set("", forKey: "phone")
                UserDefaults.standard.set("", forKey: "entityID")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    @objc func cancelAction() {
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height + (self.smartPopup?.frame.height ?? 0)
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
        self.smartPopup?.secondButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        self.smartPopup?.firstButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        view.addSubview(overlayView)
        self.view.addSubview(self.smartPopup ?? UIView())
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.smartPopup?.frame.origin.y = self.view.bounds.height - (self.smartPopup?.frame.height ?? 0)
            self.view.layoutIfNeeded()
        }
    }
    
    func setupOverlayView() {
        self.overlayView = UIView(frame: view.bounds)
        self.overlayView.backgroundColor = .clear
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.overlayView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func getUpdateStatus(token: String) {
        self.apiManager.getUpdateEntityStatus(token: accessToken) { response in
            switch response {
            case .success(let success):
                let statusCode = success.statusCode
    
                switch statusCode {
                case 200:
                    self.getWelcomeData()
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken)
                    self.getWelcomeData()
                default:
                    print("Invalid")
                }
            case .failure(let failure):
                print("Invalid \(failure)")
            }
        }
    }
    
    func getBookingLink(token: String) {
        self.apiManager.getBookingLink(token: token) { result in
            switch result {
            case .success(let success):
                self.bookingModel = success
                if let data = self.bookingModel {
                    self.bookingLink = data.data ?? ""
                }
            case .failure(let failure):
                print("Booking Link Failure: \(failure)")
            }
        }
    }
    
    func getWelcomeData() {
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
        
        self.apiManager.getWelcomeData(token: accessToken) { response in
            switch response {
            case .success(let success):
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                self.bookingButton.isHidden = false
                let statusCode = success.statusCode
                
                switch statusCode {
                    
                case 200:
                    self.welcomeData = success
                    UserDefaults.standard.set(success.data?.doctorID, forKey: "doctorID")
                    if self.welcomeData?.data?.profileCompleted == 1 {
                        self.bookingButton.isHidden = false
                        self.bookingStatusLabel.isHidden = false
                    }
                    else {
                        self.bookingButton.isHidden = true
                    }
                    self.welcomeTable.reloadData()
                    self.collectionview.reloadData()
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken)
                case 422:
                    self.bookingButton.isHidden = true
                    self.bookingStatusLabel.isHidden = true
                default:
                    print("Invalid case")
                }
            case .failure(let failure):
                print("Welcome Error: \(failure)")
            }
        }
    }

    @IBAction func logoutAction(_ sender: Any) {
        self.isLogoutPopup = true
        self.smartPopup(popTitle: "Logout", popMessage: "Are you sure you want to logout?", fTitle: "LOGOUT", stitle: "CANCEL")
    }
    
    @IBAction func goAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        if self.index != nil {
            vc.entityID = self.index
        } else {
            vc.entityID = nil
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        self.getBookingLink(token: accessToken)
        if self.bookingLink != "" {
            guard let url = URL(string: self.bookingLink) else {
                print("Error: Invalid URL string provided.")
                return
            }
            
            let urlToShare = [url]
            let activityViewController = UIActivityViewController(activityItems: urlToShare, applicationActivities: nil)
            self.view.layoutIfNeeded()
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension WelcomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
            cell.selectionStyle = .none
            cell.settingLabel.text = "Profile Settings"
            cell.iconImage.image = UIImage(systemName: "person.fill")
            return cell
        default:
            print("")
        }
        return UITableViewCell()
    }
    
    func toggleValueChanged(isOn: Bool) {
        if !isOn {
            let alert = UIAlertController(title: "", message: "Are you sure you want to OFF Booking Link Status?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.getUpdateStatus(token: self.accessToken)
            }
            let action = UIAlertAction(title: "Cancel", style: .default) { _ in
                self.switchState = isOn
                self.welcomeTable.reloadData()
            }
            alert.addAction(okAction)
            alert.addAction(action)
            navigationController?.present(alert, animated: true)
        }
        else {
            let alert = UIAlertController(title: "", message: "Are you sure you want to ON Booking Link Status", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.getUpdateStatus(token: self.accessToken)
            }
            let action = UIAlertAction(title: "Cancel", style: .default) { _ in
                self.switchState = isOn
                self.welcomeTable.reloadData()
            }
            alert.addAction(okAction)
            alert.addAction(action)
            navigationController?.present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
            vc?.navigatingFrom = "Welcome"
            navigationController?.pushViewController(vc!, animated: true)
        default:
            print("Invalid selection")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension WelcomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClinicsCollectionViewCell", for: indexPath) as? ClinicsCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        
        if let data = self.welcomeData?.data {
            cell.fromHome = false
            cell.entityDetails = data.entityDetails
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

extension WelcomeViewController : SelectClinicDelegate {
    
    func selectClinic(cell: ClinicsCollectionViewCell, index: Int?) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.entityID = index
        navigationController?.pushViewController(vc, animated: true)
    }
}

