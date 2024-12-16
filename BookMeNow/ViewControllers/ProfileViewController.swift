//
//  ProfileViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 05/02/24.
//

import UIKit
import PhotosUI

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userQualification: UILabel!
    @IBOutlet weak var userDesignation: UILabel!
    @IBOutlet weak var userDescription: UITextView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var topView: UIImageView!
    
    let apiManager = APIManager()
    var welcomeData : ProfileModel?
    let helper = Helper()
    
    var navigatingFrom : String?
    
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    let mobile = UserDefaults.standard.string(forKey: "phone") ?? ""
    let entityID = UserDefaults.standard.integer(forKey: "entityID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        Helper.helper.ViewModification(myView: topView, mycorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], myCornerRadius: 15)
        self.setupProfileImage()
        self.getProfileData()
    }
    
    func startIndicator() {
        self.indicatorView.isHidden = false
        self.indicator.startAnimating()
    }
    
    func stopIndicator() {
        self.indicatorView.isHidden = true
        self.indicator.stopAnimating()
    }
    
    func getProfileData() {
        self.startIndicator()
        self.apiManager.getProfile(phone: mobile, token: self.accessToken) { response in
               switch response {
               case .success(let data):
                   self.welcomeData = data
                   let statusCode = self.welcomeData?.statusCode

                   switch statusCode {
                   case 200 :
                       self.stopIndicator()
                       self.setProfileData(data: data)
                       /*let count = (self.welcomeData?.data?.additionalInfo?.count)
                       self.tableHeight.constant += CGFloat(count ?? 0) * 185*/
                   case 403 :
                       self.helper.generateAccessToken(token: self.refreshToken) { flag, response, _ in
                           switch flag {
                           case true:
                               self.getProfileData()
                           case false:
                               print("Error generating token")
                           }
                       }
                   default:
                       self.stopIndicator()
                       Utility.showMessage(message: self.welcomeData?.message ?? "", controller: self)
                   }
               case .failure(let error):
                   self.stopIndicator()
                   Utility.showMessage(message: "Network issue is occurred.. Please try again later.", controller: self)
            }
        }
    }
    
    func setProfileData(data: ProfileModel?) {
        if let data = data?.data {
            self.userName.text = data.doctorName
            /* for those description & qualification are nil
            //userDescription.text = data.description
            //userQualification.text = data.qualification
            //userFee.text = "₹\(data.amountDetails?.consultationChargeWithoutTax ?? "")"*/
            self.helper.downloadImage(from: data.profileImageURL ?? "") { image in
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            }
            self.userDesignation.text = data.departmentName
        }
    }
    
    func setupProfileImage() {
        self.profileImage.layer.cornerRadius = 10
        self.profileImage.contentMode = .scaleAspectFill
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callAction(_ sender: Any) {
        self.helper.makeCall()
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return welcomeData?.data?.additionalInfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        if let data = welcomeData?.data?.additionalInfo?[indexPath.row] {
            cell.entityName.text = data.entityName
            cell.consultationFee.text = "₹\(data.consultationCharge ?? 0.0)"
            cell.consultationDuration.text = "\(data.consultationTime ?? 0) min"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
}

/*@IBAction func changeProfilePicture(_ sender: Any) {
    presentPhotoPicker()
}

@IBAction func continueAction(_ sender: Any) {
    if navigatingFrom == "Welcome" {
        navigationController?.popViewController(animated: true)
    } else {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
}
 
 func presentPhotoPicker() {
     var configuration = PHPickerConfiguration()
     configuration.filter = .images
     
     let picker = PHPickerViewController(configuration: configuration)
     picker.delegate = self
     present(picker, animated: true)
 }

 extension ProfileViewController : PHPickerViewControllerDelegate {
     
     func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
         dismiss(animated: true)
         
         guard let itemProvider = results.first?.itemProvider else { return }
         
         if itemProvider.canLoadObject(ofClass: UIImage.self) {
             itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {(image, error) in
                 if let image = image as? UIImage {
                     DispatchQueue.main.async {
                         self.profileImage.image = image
                     }
                 }
             })
         }
     }
 }*/
