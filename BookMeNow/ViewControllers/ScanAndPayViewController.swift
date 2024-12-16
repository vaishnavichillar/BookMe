//
//  ScanAndPayViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 05/02/24.
//

import UIKit

class ScanAndPayViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var QRImage: UIImageView!
    @IBOutlet weak var bankLogo: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var UPIID: UILabel!
    
    var bookingID: Int?
    var doctorName: String?
    
    let helper = Helper()
    var apiManager = APIManager()
    var updatedData: BookingUpdateModel?
    let viewModel = ScanAndPayViewModel()
    
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.nameLabel.text = self.doctorName
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.helper.downloadImage(from: "https://www.chillarpayments.com/Demo/Direct-Book/images/Wc2xbVeJl0d6cyfWGCxlvcsxxYogVqsJElJy5tvN.jpeg") { image in
            DispatchQueue.main.async {
                self.profileImage.image = image
            }
        }
        self.QRImage.image = self.viewModel.generateQRCode(from: "\("upi://pay?pa=merchant.vpa@upi&pn=Merchant Name&am=100&cu=INR")")
    }
    
    func getBookingUpdate(bookingID : Int, token: String) {
        self.apiManager.getBookingUpdateStatus(bookingID: bookingID, token: token) { response in
            switch response {
            case .success(let success):
                self.updatedData = success
                let statusCode = self.updatedData?.statusCode
                
                switch statusCode {
                case 200:
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessPaymentViewController")
                    self.navigationController?.pushViewController(vc, animated: true)
                case 403:
                    self.helper.generateAccessToken(token: self.refreshToken)
                default:
                    print("Invalid Code")
                }
            case .failure(let failure):
                print("Booking Update Error : \(failure)")
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func initiateUPIPayment(payeeVPA: String, payeeName: String, amount: Double, note: String = "") {
      let amountInPaisa = amount * 100 // Convert rupees to paisa
      var urlComponents = URLComponents()
      urlComponents.scheme = "upi"
      urlComponents.path = "/pay"
      urlComponents.queryItems = [
        URLQueryItem(name: "pa", value: payeeVPA),
        URLQueryItem(name: "pn", value: payeeName),
        URLQueryItem(name: "am", value: String(amountInPaisa)),
        URLQueryItem(name: "cu", value: "INR"),
      ]
      if !note.isEmpty {
        urlComponents.queryItems?.append(URLQueryItem(name: "tn", value: note))
      }
      
      guard let url = urlComponents.url else { return }
      
      if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:]) { (success) in
            if !success {
              print("Error opening UPI app")
            }
         }
      }
      else {
          print("No UPI app found on device")
       }
    }
    
    @IBAction func cashAction(_ sender: Any) {
        self.getBookingUpdate(bookingID: bookingID ?? 0, token: accessToken)
        /*let payeeVPA = "neshwaparveenn-1@oksbi"
        let payeeName = "Merchant Name"
        let amount = 100.00
        let note = "Payment for your order"

        initiateUPIPayment(payeeVPA: payeeVPA, payeeName: payeeName, amount: amount, note: note)*/
    }
    
    @IBAction func upiAction(_ sender: Any) {
        self.getBookingUpdate(bookingID: bookingID ?? 0, token: accessToken)
    }
}
