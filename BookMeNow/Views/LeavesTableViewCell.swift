//
//  LeavesTableViewCell.swift
//  BookMeNow
//
//  Created by Neshwa on 03/09/24.
//

import UIKit

class LeavesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var daylabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!

    weak var delegate: RemoveLeaveDelagate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func removeLeaveAction(_ sender: Any) {
        delegate?.removeLeave(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

protocol RemoveLeaveDelagate : AnyObject {
    func removeLeave(cell: LeavesTableViewCell)
}
