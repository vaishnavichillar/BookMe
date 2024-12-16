//
//  ClinicsDetailsCollectionViewCell.swift
//  BookMeNow
//
//  Created by Neshwa on 18/06/24.
//

import UIKit

class ClinicsDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var logoTitle: UILabel!
    @IBOutlet weak var entityName: UILabel!
    
    var entityID : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleView.layer.cornerRadius = titleView.frame.size.height / 2
        titleView.layer.borderWidth = 1.5
        titleView.layer.borderColor = UIColor.black.cgColor
    }

}
