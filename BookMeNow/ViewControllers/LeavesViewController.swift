//
//  LeavesViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 03/09/24.
//

import UIKit

class LeavesViewController: UIViewController {

    @IBOutlet weak var leavesTable: UITableView!
    @IBOutlet weak var noLeaveLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leavesTable.delegate = self
        self.leavesTable.dataSource = self
        self.leavesTable.layer.cornerRadius = 10
        self.leavesTable.register(UINib(nibName: "LeavesTableViewCell", bundle: nil), forCellReuseIdentifier: "LeavesTableViewCell")
    }
    
    @IBAction func backAction(_ sender: Any) {
        
    }
    
    @IBAction func addleaveAction(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController else { return }
        vc.addLeave = true
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: false)
    }
}

extension LeavesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeavesTableViewCell", for: indexPath) as? LeavesTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

extension LeavesViewController : RemoveLeaveDelagate {
    func removeLeave(cell: LeavesTableViewCell) {
        let index = leavesTable.indexPath(for: cell)
    }
}
