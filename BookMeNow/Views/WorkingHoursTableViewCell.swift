//
//  WorkingHoursTableViewCell.swift
//  BookMeNow
//
//  Created by Neshwa on 08/02/24.
//

import UIKit

class WorkingHoursTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var statusToggle: UISwitch!
    @IBOutlet weak var timeIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeView.layer.cornerRadius = 10
        dayLabel.isHidden = true
    }
    
    func setWorkHoursData(with data: WorkSchedule) {
        dayLabel.text = data.day
        startTime.text = data.startTime
        endTime.text = data.endTime
        if data.session == "Morning" {
            timeIcon.image = UIImage(named: "am")
        } else {
            timeIcon.image = UIImage(named: "pm")
        }
        if data.session == nil {
            timeIcon.isHidden = true
        } else {
            timeIcon.isHidden = false
        }
        if data.status == 1 {
            statusToggle.isOn = true
        } else {
            statusToggle.isOn = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
