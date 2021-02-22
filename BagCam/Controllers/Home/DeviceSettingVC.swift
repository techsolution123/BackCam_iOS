//
//  DeviceSettingVC.swift
//  BagCam
//
//  Created by Kevin Shah on 19/02/21.
//

import UIKit

/// DeviceSettingVC
class DeviceSettingVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var btnRemoveDevice: UIButton!
    
    /// Variable Declaration(s)
    var arrDeviceInfoType: [DeviceInfoType] = DeviceInfoType.allCases
    
    /// Variable Declaration(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

// MARK: - UI Related Method(s)
extension DeviceSettingVC {
    
    func prepareUI() {
        registerTableCell()
    }
    
    func registerTableCell() {
        self.tableView.register(UINib(nibName: "EditDeviceNameTableCell", bundle: nil), forCellReuseIdentifier: "EditDeviceNameTableCell")
        self.tableView.register(UINib(nibName: "DeviceInfoTableCell", bundle: nil), forCellReuseIdentifier: "DeviceInfoTableCell")
    }
}

// MARK: - UIButton Action(s)
extension DeviceSettingVC {
    
    @IBAction func tapBtnRemoveDevice(_ sender: UIButton) {
        
    }
}

// MARK: - UITableView Delegate and DataSource
extension DeviceSettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDeviceInfoType.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 0) ? 220 : 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditDeviceNameTableCell", for: indexPath) as! EditDeviceNameTableCell
            cell.tag = indexPath.row
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceInfoTableCell", for: indexPath) as! DeviceInfoTableCell
        cell.tag = indexPath.row
        cell.deviceInfoType = arrDeviceInfoType[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
