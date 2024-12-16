//
//  RegisterDetailsViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 04/02/24.
//

import UIKit

class RegisterDetailsViewController: UIViewController {
    
    @IBOutlet weak var registerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTable.delegate = self
        self.registerTable.dataSource = self
        self.registerTable.register(UINib(nibName: "RegisterTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisterTableViewCell")
    }

    @IBAction func backAction(_ sender: Any) {
    }
    
    @IBAction func continueAction(_ sender: Any) {
    }
}

extension RegisterDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableViewCell", for: indexPath) as! RegisterTableViewCell
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.valueField.placeholder = "Shop Name"
        case 1:
            cell.valueField.placeholder = "Shop Building Name"
        case 2:
            cell.valueField.placeholder = "Shop Street Name"
        case 3:
            cell.valueField.placeholder = "Shop City"
        case 4:
            cell.valueField.placeholder = "Shop State"
        case 5:
            cell.valueField.placeholder = "Shop District"
        case 6:
            cell.valueField.placeholder = "Shop Pincode"
        case 7:
            cell.valueField.placeholder = "Email Address"
        case 8:
            cell.valueField.addLeftText(text: "+91 ")
            cell.valueField.placeholder = "Contact Number"
        default:
            print("Invalif")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
