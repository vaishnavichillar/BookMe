//
//  ToggleSettingsTableViewCell.swift
//  BookMeNow
//
//  Created by Neshwa on 04/02/24.
//

import UIKit

class ToggleSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var settingTitle: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    weak var delegate: ToggleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 10
    }
    
    @IBAction func changeToggleValue(_ sender: UISwitch) {
        delegate?.toggleValueChanged(isOn: sender.isOn)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
