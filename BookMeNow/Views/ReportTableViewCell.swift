//
//  ReportTableViewCell.swift
//  BookMeNow
//
//  Created by Neshwa on 05/02/24.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var IDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 15
    }
    
    func configure(with data: BookingReport) {
        nameLabel.text = data.customerName
//        feeLabel.text = "₹\(data.amount)"
        IDLabel.text = data.orderID
        if data.bookingStatus == 1 {
            statusImage.image = UIImage(named: "accepted")
            statusImage.tintColor = UIColor.systemGreen
        } else if data.bookingStatus == 0 {
            statusImage.image = UIImage(named: "pending")
            statusImage.tintColor = UIColor.systemOrange
        } else {
            statusImage.image = UIImage(systemName: "xmark.circle.fill")
            statusImage.tintColor = UIColor.systemRed
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
