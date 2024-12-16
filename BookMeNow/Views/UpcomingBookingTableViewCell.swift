//
//  UpcomingBookingTableViewCell.swift
//  BookMeNow
//
//  Created by Neshwa on 03/02/24.
//

import UIKit

class UpcomingBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var appoinmentTime: UILabel!
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var appoinmentStatus: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var callButton: UIImageView!
    @IBOutlet weak var statusToViewLength: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 10

    }
    
    func configure(with data: AppointmentList) {
        appoinmentTime.text = data.timeSlot
        patientName.text = data.customerName
        
        if data.bookingStatus == 1 {
            appoinmentStatus.text = "Done"
            appoinmentStatus?.textColor = UIColor.systemGreen
        } else {
            appoinmentStatus.text = "Pending"
            appoinmentStatus?.textColor = UIColor.systemOrange
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
