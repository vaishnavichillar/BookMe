//
//  HeaderView.swift
//  BookMeNow
//
//  Created by Neshwa on 12/02/24.
//

import Foundation
import UIKit

class HeaderView : UIView {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var weekDayLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    private func configureView() {
        let bundle = Bundle.main
        if let viewToAdd = bundle.loadNibNamed(HeaderView.identifier(), owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            contentView.layer.cornerRadius = 10
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
}
