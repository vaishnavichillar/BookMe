//
//  LogoutViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 06/02/24.
//

import UIKit

class LogoutViewController: UIViewController {

    @IBOutlet weak var customView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customView.layer.cornerRadius = 10
        let alertController = UIAlertController(title: "LOGOUT", message: "What would you like to do?", preferredStyle: .actionSheet)
            let sendButton = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
            })
            let  deleteButton = UIAlertAction(title: "Delete forever", style: .destructive, handler: { (action) -> Void in
                print("Delete button tapped")
            })
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                self.navigationController?.popViewController(animated: true)
                print("Cancel button tapped")
            })
            alertController.addAction(sendButton)
            alertController.addAction(deleteButton)
            alertController.addAction(cancelButton)
            navigationController?.present(alertController, animated: true)
    }
}
