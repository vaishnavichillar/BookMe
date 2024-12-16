//
//  SuccessOnboardViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 21/09/24.
//

import UIKit

class SuccessOnboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
