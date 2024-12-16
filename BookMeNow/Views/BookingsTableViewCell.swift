//
//  BookingsTableViewCell.swift
//  BookMeNow
//
//  Created by Neshwa on 07/02/24.
//

import UIKit

class BookingsTableViewCell: UITableViewCell {

    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var callButton: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var callImage: UIImageView!
    @IBOutlet weak var callTitle: UILabel!
    @IBOutlet weak var circleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10
        callView.layer.cornerRadius = 10
        callView.layer.borderWidth = 1
        
    }
    
    func configure(with data: AppointmentList) {
        patientName.text = data.customerName
        timeLabel.text = data.timeSlot
        if data.bookingStatus == 1 {
            statusLabel.text = "Done"
            statusLabel.textColor = UIColor.appGreen
            callView.layer.borderColor = UIColor.lightGray.cgColor
            callImage.tintColor = UIColor.lightGray
            callTitle.textColor = UIColor.lightGray
            circleImage.tintColor = UIColor.lightGray
        } else {
            callView.layer.borderColor = UIColor.appTheme.cgColor
            callImage.tintColor = UIColor.appTheme
            callTitle.textColor = UIColor.appTheme
            statusLabel.text = "Pending"
            statusLabel.textColor = UIColor.appRed
            circleImage.tintColor = UIColor.appTheme
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
