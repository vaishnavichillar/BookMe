//
//  WorkHoursViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 04/08/24.
//

import UIKit

class WorkHoursViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var pickerviewHeight: NSLayoutConstraint!
    @IBOutlet weak var monthButton: UIButton!
    
    let calendar = Calendar.current
    var daysInMonth = [Date]()
    
    var monthNames : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        pickerView.delegate = self
//        pickerView.dataSource = self
        
        monthNames = calendar.standaloneMonthSymbols
        
        monthButton.showsMenuAsPrimaryAction = true
        
        let menu = UIMenu(title: "", options: .displayInline, children: [
                    UIAction(title: "Option 1") { _ in
                        // Handle option 1 selection
                    },
                    UIAction(title: "Option 2") { _ in
                        // Handle option 2 selection
                    }
                ])

        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(UINib(nibName: "WorkingHoursCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WorkingHoursCollectionViewCell")
        
      /*  let today = Date()
        let components = calendar.dateComponents([.year, .month], from: today)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM" // For full month name
        // Or use "MMM" for abbreviated month name

        let currentMonthString = dateFormatter.string(from: Date())
        
        monthButton.setTitle(currentMonthString, for: .normal)
        let startOfMonth = calendar.date(from: components)!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
                
        for day in range.startIndex..<range.endIndex {
            let date = calendar.date(byAdding: .day, value: day, to: startOfMonth)!
            daysInMonth.append(date)
        }
       print(daysInMonth) */
        
        daysInMonth = createDatesArray(daysFromNow: 28)
        print("daysInMonth \(daysInMonth)")
        collectionview.reloadData()
    }
    
    @IBAction func selectAMonth(_ sender: Any) {
        
        let actions = monthNames.map { month in
            UIAction(title: month) { _ in
                //print("Selected month: \(month)")
                self.monthButton.setTitle(month, for: .normal)
            }
        }
        let menu = UIMenu(title: "", children: actions)
        monthButton.menu = menu
        
    }

    func createDatesArray(daysFromNow: Int) -> [Date] {
        let currentDate = Date()
        let futureDate = Calendar.current.date(byAdding: .day, value: daysFromNow, to: currentDate)!

        var dateArray: [Date] = []
        var currentDay = currentDate

        while currentDay <= futureDate {
            dateArray.append(currentDay)
            currentDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDay)!
        }

        return dateArray
    }
}

extension WorkHoursViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkingHoursCollectionViewCell", for: indexPath) as? WorkingHoursCollectionViewCell else { return UICollectionViewCell() }
            let date = daysInMonth[indexPath.row] - 1
            //let dayOfWeek = calendar.component(.weekday, from: date)
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d"
                
            cell.dayLabel.text = dayFormatter.string(from: date)
            cell.dateLabel.text = dateFormatter.string(from: date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}

//extension WorkHoursViewController : UIPickerViewDelegate, UIPickerViewDataSource {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return monthNames.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 45
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return monthNames[row]
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        UIView.animate(withDuration: 0.3) {
//            self.pickerviewHeight.constant = 250
//        }
//    }
//}
