//
//  ViewAllDoctorsCollectionViewCell.swift
//  BookMeNow
//
//  Created by Neshwa on 03/02/24.
//

import UIKit

class ViewAllDoctorsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameID: UILabel!
    @IBOutlet weak var DoctorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoImage.layer.cornerRadius = logoImage.frame.height / 2
        logoImage.clipsToBounds = true
    }

}
