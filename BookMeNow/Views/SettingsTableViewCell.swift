//
//  SettingsTableViewCell.swift
//  BookMeNow
//
//  Created by Neshwa on 04/02/24.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
