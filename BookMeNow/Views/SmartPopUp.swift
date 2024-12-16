//
//  SmartPopUp.swift
//  BookMeNow
//
//  Created by Neshwa on 07/02/24.
//

import Foundation
import UIKit

class SmartPopUp: UIView {

    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupMessage: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    var bookingID: Int?
    var mobileNumber: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureView() {
        let bundle = Bundle.main
        if let viewToAdd = bundle.loadNibNamed(SmartPopUp.identifier(), owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
}

