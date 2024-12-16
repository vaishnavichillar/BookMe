//
//  ClinicsCollectionViewCell.swift
//  BookMeNow
//
//  Created by Neshwa on 18/06/24.
//

protocol SelectClinicDelegate : AnyObject {
    func selectClinic(cell: ClinicsCollectionViewCell, index: Int?)
}

import UIKit

class ClinicsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionview: UICollectionView!
    
    var entityDetails : [WelcomeEntityDetails]?
    var entitDetailsData : [EntityDetails]?
    
    var fromHome = Bool()
    
    var changeColor = Bool()
    
    weak var delegate : SelectClinicDelegate?
    
    var selectedIndexPath: IndexPath?
    var viewAllSelectedIndexPath: IndexPath?
    
    let index = UserDefaults.standard.integer(forKey: "SelectedIndex")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(UINib(nibName: "ClinicsDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ClinicsDetailsCollectionViewCell")
    }

}

extension ClinicsCollectionViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return 1
            
        case 1:
            return entitDetailsData?.count ?? 0
            
        default:
            return 0
        }
    }
    
    func getFirstLettersOfSentence(_ sentence: String?) -> String {
        guard let sentence = sentence, !sentence.isEmpty else {
            return ""
        }
        
        let words = sentence.split(separator: " ")
       
        let firstLetters = words.compactMap { $0.first }.map { String($0) }.joined()
        
        return firstLetters
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClinicsDetailsCollectionViewCell", for: indexPath) as? ClinicsDetailsCollectionViewCell else { return UICollectionViewCell() }
            cell.entityName.text = "View All"
            cell.logoTitle.text = "ALL"
            
            let index = UserDefaults.standard.integer(forKey: "SelectedIndex")
            
            if viewAllSelectedIndexPath == nil {
                if index == 0 {
                    cell.titleView.backgroundColor = UIColor(hex: "D9E7FE")
                } else {
                    cell.titleView.backgroundColor = UIColor.systemGray6
                }
                
            } else {
                if index == 0 {
                    cell.titleView.backgroundColor = UIColor(hex: "D9E7FE")
                } else {
                    cell.titleView.backgroundColor = UIColor.systemGray6
                }
            }
            
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClinicsDetailsCollectionViewCell", for: indexPath) as? ClinicsDetailsCollectionViewCell else { return UICollectionViewCell() }
            
            let index = UserDefaults.standard.integer(forKey: "SelectedIndex")
            
            if let data = entitDetailsData?[indexPath.item] {
                cell.entityName.text = data.entityName
                cell.logoTitle.text = getFirstLettersOfSentence(data.entityName ?? "").uppercased()
                cell.entityID = data.entityID
                
                if selectedIndexPath == nil {
                    if index == data.entityID {
                        cell.titleView.backgroundColor = UIColor(hex: "D9E7FE")
                    } else {
                        cell.titleView.backgroundColor = UIColor.systemGray6
                    }
                } else {
                    if indexPath == selectedIndexPath {
                        cell.titleView.backgroundColor = UIColor(hex: "D9E7FE")
                    } else {
                        cell.titleView.backgroundColor = UIColor.systemGray6
                    }
                }
            }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            viewAllSelectedIndexPath = IndexPath(row: 1, section: 0)
            selectedIndexPath = nil
            UserDefaults.standard.setValue(0, forKey: "SelectedIndex")
            UserDefaults.standard.setValue(nil, forKey: "entityID")
            delegate?.selectClinic(cell: self, index: nil)
            collectionView.reloadData()
            
        case 1:
            viewAllSelectedIndexPath = nil
            if let previousIndexPath = selectedIndexPath {
                let previousCell = collectionView.cellForItem(at: previousIndexPath) as? ClinicsDetailsCollectionViewCell
            previousCell?.titleView.backgroundColor = .white
            }
               
            let currentCell = collectionView.cellForItem(at: indexPath) as? ClinicsDetailsCollectionViewCell
            currentCell?.titleView.backgroundColor = UIColor(hex: "D9E7FE")

            selectedIndexPath = indexPath
            
            if let data = entitDetailsData?[indexPath.item] {
                UserDefaults.standard.setValue(data.entityID, forKey: "SelectedIndex")
                UserDefaults.standard.setValue(data.entityID, forKey: "entityID")
                delegate?.selectClinic(cell: self, index: data.entityID ?? 0)
                collectionView.reloadData()
            }
            
        default:
            print("Invalid cell")
        }
        
    }
}
