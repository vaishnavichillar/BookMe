//
//  WorkingHoursViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 08/02/24.
//

import UIKit

class WorkingHoursViewController: UIViewController {

    @IBOutlet weak var workingHoursTable: UITableView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let date = Date()
    var doctorID : Int?
    var entityID : Int?
    var selectedDate: String?
    var navigatingFrom : String?
    
    let helper = Helper()
    let apiManager = APIManager()
    var workData : WorkingHoursModel?
    var workScheduleData : [WorkSchedule]? = []
    
    let entityId = UserDefaults.standard.integer(forKey: "entityID")
    let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getWorkHours()
        self.workingHoursTable.delegate = self
        self.workingHoursTable.dataSource = self
        self.workingHoursTable.register(UINib(nibName: "WorkingHoursTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkingHoursTableViewCell")
        self.workingHoursTable.showsVerticalScrollIndicator = false
    }
    
    func getWorkHours() {
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
        self.apiManager.getWorkingHours(doctorID: "\(self.doctorID ?? 0)",entityID: "\(self.entityId)",token: self.accessToken) { response in
            switch response {
            case .success(let success):
                self.indicatorView.isHidden = true
                self.indicator.stopAnimating()
                self.workData = success
                let statusCode = self.workData?.statusCode
                switch statusCode {
                    
                case 200:
                    self.workingHoursTable.reloadData()
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken) { flag, response, _ in
                        switch flag {
                        case true:
                            self.getWorkHours()
                        case false:
                            print("Error generating token")
                        }
                    }
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
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if self.navigatingFrom == "Welcome" {
            navigationController?.popViewController(animated: true)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func callAction(_ sender: Any) {
        self.helper.makeCall()
    }
}

extension WorkingHoursViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.workData?.data?.result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemInSection =  self.workData?.data?.result?[section]
        let workScheduleItems = itemInSection?.workSchedule?.filter { $0.status != 0 }
        return workScheduleItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkingHoursTableViewCell", for: indexPath) as? WorkingHoursTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        if let workSchedule = self.workData?.data?.result?[indexPath.section].workSchedule?[indexPath.row] {
            cell.setWorkHoursData(with: workSchedule)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.workData?.data?.result?[section].day
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        //headerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        headerView.backgroundColor = UIColor.systemGray5
        headerView.layer.cornerRadius = 10
        
        let label = UILabel()
        label.textColor = UIColor.init(hex: "000000")
        label.font = UIFont.boldSystemFont(ofSize: 15)
        headerView.addSubview(label)
        label.text = workData?.data?.result?[section].day
        label.frame = CGRect(x: 15, y: 5, width: tableView.frame.size.width - 80, height: 30)
        /* let statusToggle = UISwitch()
        
        statusToggle.frame = CGRect(x: label.frame.maxX, y: 5, width: 50, height: 30)
        if let data = workData?.data?.result?[section].dayStatus {
            if data == 1 {
                statusToggle.isOn = true
            } else {
                statusToggle.isOn = false
            }
        }
        headerView.addSubview(statusToggle) */
        return headerView
    }
}
