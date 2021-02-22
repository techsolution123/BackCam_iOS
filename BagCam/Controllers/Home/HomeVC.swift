//
//  HomeVC.swift
//  BagCam
//
//  Created by Kevin Shah on 19/02/21.
//

import UIKit

/// HomeVC
class HomeVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var btnAddDevice: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    // Sending data or navigating to another screen
    ///
    /// - Parameters:
    ///   - segue: segue identifier can be multiple
    ///   - sender: can be nil or carried the content data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFullDevicePairingVC" {
            let destVC = segue.destination as! FullDevicePairingVC
            destVC.isFromHomeVC = true
        } else if segue.identifier == "segueDeviceSettingVC" {
            
        }
    }
    
    @IBAction func unwindHomeVC(_ sender: UIStoryboardSegue) {
        
    }
}

// MARK: - UI Related Method(s)
extension HomeVC {
    
    func prepareUI() {
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 60, right: 0)
        registerTableCell()
    }
    
    func registerTableCell() {
        self.tableView.register(UINib(nibName: "AddDeviceTableCell", bundle: nil), forCellReuseIdentifier: "AddDeviceTableCell")
        self.tableView.register(UINib(nibName: "DeviceListTableCell", bundle: nil), forCellReuseIdentifier: "DeviceListTableCell")
    }
}

// MARK: - UIButton Action(s)
extension HomeVC {
    
    @IBAction func tapBtnAddDevice(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueFullDevicePairingVC", sender: nil)
    }
}

// MARK: - UITableView Delegate and DataSource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceListTableCell", for: indexPath) as! DeviceListTableCell
        cell.parentHomeVC = self
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
