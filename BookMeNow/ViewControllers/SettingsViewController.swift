//
//  SettingsViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 05/02/24.
//

import UIKit

class SettingsViewController: UIViewController, ToggleCellDelegate {
 
    @IBOutlet weak var workingHoursView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var bankDetails: UIView!
    
    var welcomeData: WelcomeModel?
    let apiManager = APIManager()
    let helper = Helper()
    
    var fromGeneralSettings = Bool()
    var switchState = Bool()
    var navigatingFrom = "Settings"
    
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.workingHoursView.layer.cornerRadius = 10
        self.bankDetails.layer.cornerRadius = 10
        self.profileView.layer.cornerRadius = 10
        self.getsettingsData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(workHoursTapped))
        self.workingHoursView.addGestureRecognizer(tapGesture)
        let bankTapGesture = UITapGestureRecognizer(target: self, action: #selector(bankAccountTapped))
        self.bankDetails.addGestureRecognizer(bankTapGesture)
        
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        self.profileView.addGestureRecognizer(profileTapGesture)
    }
    
    @objc func workHoursTapped() {
       /* let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WorkingHoursViewController") as? WorkingHoursViewController
        vc?.doctorID = welcomeData?.data?.doctorID
        vc?.entityID = welcomeData?.data?.entityDetails?[0].entityID
        print("The entityID in WelcomePage is \(welcomeData?.data?.entityDetails?[0].entityID)")
        vc?.navigatingFrom = navigatingFrom
        navigationController?.pushViewController(vc!, animated: true)*/
       guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditHoursViewController") as? EditHoursViewController else { return }
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func bankAccountTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BankAccountViewController") as? BankAccountViewController
        vc?.navigatingFrom = navigatingFrom
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func profileTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        vc?.navigatingFrom = navigatingFrom
        navigationController?.pushViewController(vc!, animated: true)
    }

    func getsettingsData() {
        self.apiManager.getWelcomeData(token: self.accessToken) { response in
            switch response {
            case .success(let success):
                let statusCode = success.statusCode
                
                switch statusCode {
                case 200:
                    self.welcomeData = success
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken) { flag, _, _ in
                        switch flag {
                        case true:
                            self.getsettingsData()
                        case false:
                            print("Error generating token")
                        }
                    }
                default:
                    Utility.showMessage(message: success.message, controller: self)
                }
            case .failure(let failure):
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
    
    func getUpdateStatus(token: String) {
        self.apiManager.getUpdateEntityStatus(token: self.accessToken) { response in
            switch response {
            case .success(let success):
                let statusCode = success.statusCode
                
                switch statusCode {
                case 200:
                    self.getsettingsData()
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken) { flag, _, _ in
                        switch flag {
                        case true:
                            self.getUpdateStatus(token: token)
                        case false:
                            print("Error generating token")
                        }
                    }
                default:
                    Utility.showMessage(message: success.message, controller: self)
                }
                
            case .failure(let failure):
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        /*case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleSettingsTableViewCell", for: indexPath) as! ToggleSettingsTableViewCell
            cell.selectionStyle = .none
            
            cell.delegate = self
            cell.settingTitle.text = "Available"
            cell.iconImage.image = UIImage(systemName: "bag.fill")
            let entityStatus = welcomeData?.data?.entityStatus
            if entityStatus == 1 {
                cell.toggleSwitch.isOn = true
            } else {
                cell.toggleSwitch.isOn = false
            }
            switchState = cell.toggleSwitch.isOn
            return cell*/
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
            cell.selectionStyle = .none
            cell.settingLabel.text = "Profile Settings"
            cell.iconImage.image = UIImage(systemName: "person.fill")
            return cell
        default:
            print("Something went wrong")
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
            navigationController?.pushViewController(vc!, animated: true)

        default:
            print("Invalid selection")
        }
    }
    
    func toggleValueChanged(isOn: Bool) {
        print("toggle value : \(isOn)")
        if !isOn {
            let alert = UIAlertController(title: "", message: "Are you sure you want to change your status?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.getUpdateStatus(token: self.accessToken)
            }
            let action = UIAlertAction(title: "Cancel", style: .default) { _ in
                self.switchState = isOn
                
            }
            alert.addAction(okAction)
            alert.addAction(action)
            navigationController?.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "", message: "Are you sure you want to change your status?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.getUpdateStatus(token: self.accessToken)
            }
            let action = UIAlertAction(title: "Cancel", style: .default) { _ in
                self.switchState = isOn
                
            }
            alert.addAction(okAction)
            alert.addAction(action)
            navigationController?.present(alert, animated: true)
        }
    }
}
