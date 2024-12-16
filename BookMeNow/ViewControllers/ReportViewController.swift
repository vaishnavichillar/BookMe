//
//  ReportViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 05/02/24.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var reportTable: UITableView!
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var totalReports: UILabel!
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let date = Date()
    var selectedDate: String?
    
    let apiManager = APIManager()
    var reportData: ReportModel?
    let helper = Helper()
    
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    let doctorID = UserDefaults.standard.string(forKey: "doctorID") ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCurrentDate()
        self.getReport()
        self.reportTable.delegate = self
        self.reportTable.dataSource = self
        self.dateView.layer.cornerRadius = 15
        self.customerView.layer.cornerRadius = 15
        
        self.reportTable.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCell")
        self.reportTable.layer.cornerRadius = 15
        self.reportTable.showsVerticalScrollIndicator = false
        self.selectedDate = helper.formatDate(date: date)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showCalendar))
        self.dateView.addGestureRecognizer(tapGesture)
    }
    
    @objc func showCalendar(_ sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        vc.fromReportPage = true
        vc.modalPresentationStyle = .overFullScreen
        vc.callback = { data in
            self.selectedDate = data
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            if let date = inputFormatter.date(from: data) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "d MMM yyyy"
                let formattedDate = outputFormatter.string(from: date)
                self.todayDate.text = formattedDate
                print(formattedDate)
            }
            else {
                print("Invalid date format")
            }
            self.getReport()
        }
        navigationController?.present(vc, animated: false)
    }
    
    func setCurrentDate() {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        formatter.dateFormat = "MMM"
        let monthAbbreviation = formatter.string(from: date)
        let year = calendar.component(.year, from: date)
        let day = calendar.component(.day, from: date)
        self.todayDate.text = "\(day) \(monthAbbreviation) \(year)"
    }
    
    func getReport() {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
        self.apiManager.getbookingReport(doctorId: doctorID, date: selectedDate ?? "", token: accessToken) { response in
            
            switch response {
            case .success(let success):
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                self.reportData = success
                switch self.reportData?.statusCode {
                    
                case 200:
                    self.totalReports.text = "\(self.reportData?.data?.bookingReport?.count ?? 0)"
                    if self.reportData?.data?.bookingReport?.count ?? 0 > 0 {
                        self.noDataImage.isHidden = true
                        self.reportTable.isHidden = false
                        self.reportTable.reloadData()
                    }
                    else {
                        self.noDataImage.isHidden = false
                        self.reportTable.isHidden = true
                    }
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken) { flag, response, _ in
                        switch flag {
                        case true:
                            self.getReport()
                        case false:
                            print("Error generating token")
                        }
                    }
                default:
                    print("Invalid status code")
                }
            case .failure(let failure):
                print("Report Model Error : \(failure)")
            }
        }
    }

    @IBAction func printAction(_ sender: Any) {
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension ReportViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reportData?.data?.bookingReport?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as? ReportTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let data = self.reportData?.data?.bookingReport {
            cell.configure(with: data[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
