//
//  ProfileTableViewCell.swift
//  BookMeNow
//
//  Created by Neshwa on 25/06/24.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var entityName: UILabel!
    @IBOutlet weak var consultationFee: UILabel!
    @IBOutlet weak var consultationDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
