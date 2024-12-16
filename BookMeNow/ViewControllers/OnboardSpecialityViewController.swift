//
//  OnboardSpecialityViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 20/09/24.
//

import UIKit

class OnboardSpecialityViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var specialityButton: UIButton!
    
    let viewModel = GeneralViewModel()
    
    var phone = ""
    var entityID : Int?
    var doctorID : Int?
    var departmentID: Int?
    var doctorName : String?
    
    let specialityTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var deptData: [SpecialityData] = [] {
        didSet {
            specialityTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupTable()
        self.disableSignIn()
        self.setupAction()
        self.listDepts()
    }
    
    func setup() {
        self.mainView.layer.cornerRadius = 10
        self.buttonImage.layer.cornerRadius = 10
        
        self.specialityButton.setTitleColor(.lightGray, for: .normal)
        self.specialityButton.layer.cornerRadius = 10
        self.specialityButton.layer.borderWidth = 1
        self.specialityButton.layer.borderColor = UIColor.black.cgColor
        
        var config = UIButton.Configuration.plain()
        config.title = "Select Specialisation"
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        config.imageColorTransformer = UIConfigurationColorTransformer { _ in
            return .appTheme
        }
        config.imagePadding = 8
        self.specialityButton.configuration = config
    }
    
    func setupTable() {
        self.specialityTableView.isHidden = true
        self.specialityTableView.delegate = self
        self.specialityTableView.dataSource = self
        self.specialityTableView.showsVerticalScrollIndicator = true
        view.addSubview(self.specialityTableView)
        
        NSLayoutConstraint.activate([
            self.specialityTableView.topAnchor.constraint(equalTo: self.specialityButton.bottomAnchor, constant: 0),
            self.specialityTableView.leadingAnchor.constraint(equalTo: self.specialityButton.leadingAnchor),
            self.specialityTableView.trailingAnchor.constraint(equalTo: self.specialityButton.trailingAnchor),
            self.specialityTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: self.specialityTableView.contentSize.height - 20)
            ])
    }
    
    func enableSignIn() {
        self.signInView.isUserInteractionEnabled = true
        self.signInView.alpha = 1.0
    }
    
    func disableSignIn() {
        self.signInView.isUserInteractionEnabled = false
        self.signInView.alpha = 0.5
    }
    
    func listDepts() {
        self.viewModel.listSpecialities() { result in
            switch result {
            case .success(let success):
                switch success.statusCode {
                    
                case 200:
                    if let data = success.data {
                        self.deptData = data
                    }
                default:
                    Utility.showMessage(message: success.message, controller: self)
                }
            case .failure(let failure):
                Utility.showMessage(message: failure.localizedDescription, controller: self)
            }
        }
    }
    
    @IBAction func selectDepartment(_ sender: Any) {
        self.specialityTableView.isHidden = !self.specialityTableView.isHidden
    }
    
    func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.regsiterAction))
        self.signInView.addGestureRecognizer(tap)
        self.signInView.isUserInteractionEnabled = true
    }
    
    @objc func regsiterAction() {
        /*let details = DoctorDetails(departmentID: departmentID)
        DoctorDetails.doctorData.doctorDetails = details*/
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardDaysViewController") as? OnboardDaysViewController else { return }
        vc.phone = phone
        vc.entityID = entityID
        vc.doctorID = doctorID
        vc.doctorName = doctorName
        vc.departmentID = departmentID
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

extension OnboardSpecialityViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deptData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = deptData[indexPath.row].departmentName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        specialityButton.setTitle(deptData[indexPath.row].departmentName, for: .normal)
        departmentID = deptData[indexPath.row].departmentID
        specialityButton.setTitleColor(.black, for: .normal)
        enableSignIn()
        tableView.isHidden = true
    }
}
