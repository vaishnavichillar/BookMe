//
//  BankAccountViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 09/02/24.
//

import UIKit

class BankAccountViewController: UIViewController {

    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var ifscCode: UILabel!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var holderName: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let apiManager = APIManager()
    var bankData : BankDetailsModel?
    let helper = Helper()
    
    var navigatingFrom : String?
    
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBankData()
    }
    
    func getBankData() {
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
        self.apiManager.getBankData(token: self.accessToken) { response in
            switch response {
            case .success(let success):
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                self.bankData = success
                let statusCode = success.statusCode
                
                switch statusCode {
                case 200:
                    self.bankData = success
                    if let data = self.bankData?.data {
                        self.setBankDetails(with: data.bankdata!)
                    }
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken) { flag, response, token in
                        switch flag {
                        case true:
                            self.getBankData()
                        case false:
                            print("Error generating token")
                        }
                    }
                default:
                    Utility.showMessage(message: self.bankData?.message ?? "", controller: self)
                }
            case .failure(let failure):
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
    
    func setBankDetails(with data: BankDataModel) {
        self.accountNumber.text = data.accountNo
        self.ifscCode.text = data.ifscCode
        self.bankName.text = data.bankName
        self.holderName.text = data.accountHolderName
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if navigatingFrom == "Welcome" {
            navigationController?.popViewController(animated: true)
        }
        else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func callAction(_ sender: Any) {
        self.helper.makeCall()
    }
}
