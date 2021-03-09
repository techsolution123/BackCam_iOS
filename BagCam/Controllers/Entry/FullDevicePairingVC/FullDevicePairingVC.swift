//
//  FullDevicePairingVC.swift
//  BagCam
//
//  Created by Pankaj Patel on 17/02/21.
//

import UIKit
import CoreBluetooth

/// FullDevicePairingVC
class FullDevicePairingVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var btnIDontHaveDevice: UIButton!
    
    /// Variable Declaration(s)
    var arrDisplayCellType: [DisplayCellType] = []
    var arrCBPeripheral: [CBPeripheral] = []
    var cbCentralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral!
    
    /// Carried Variable
    var isFromHomeVC: Bool = false
    
    /// DisplayCellType
    enum DisplayCellType {
        case row(_ arr: [Any])
        case devices(_ arr: [CBPeripheral])
        
        func rowHeight(_ index: Int) -> CGFloat {
            switch self {
            case .row(let arr):
                if let bagImageType = arr[index] as? BagImageType {
                    switch bagImageType {
                    case .normal:
                        return 156
                    case .connect:
                        return 234
                    }
                } else if let generalLabelInfoType = arr[index] as? GeneralLabelInfoType {
                    switch generalLabelInfoType {
                    case .accountCreated, .holdPairing, .selectBagCam:
                        return 56
                    case .addYourFirstDevice, .availableDevices:
                        return 48
                    case .devicePaired:
                        return 75
                    }
                } else {
                    return 0
                }
            case .devices:
                return 60
            }
        }
    }
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cbCentralManager?.stopScan()
    }
    
    // Sending data or navigating to another screen
    ///
    /// - Parameters:
    ///   - segue: segue identifier can be multiple
    ///   - sender: can be nil or carried the content data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueScanQRVC" {
            let destVC = segue.destination as! ScanQRVC
            destVC.isFromHomeVC = self.isFromHomeVC
            destVC.connectedPeripheral = self.connectedPeripheral
        }
    }
}

// MARK: - UI Related Method(s)
extension FullDevicePairingVC {
    
    func prepareUI() {
        registerTableCell()
        prepareDisplayCellTypeData()
        prepareBluetoothConfiguration()
    }
    
    func registerTableCell() {
        self.tableView.register(UINib(nibName: "BagTableCell", bundle: nil), forCellReuseIdentifier: "BagTableCell")
        self.tableView.register(UINib(nibName: "GeneralLabelInfoTableCell", bundle: nil), forCellReuseIdentifier: "GeneralLabelInfoTableCell")
        self.tableView.register(UINib(nibName: "DeviceNameTableCell", bundle: nil), forCellReuseIdentifier: "DeviceNameTableCell")
    }
    
    func prepareDisplayCellTypeData() {
        if !isFromHomeVC {
            self.arrDisplayCellType = [
                .row([BagImageType.normal,
                      GeneralLabelInfoType.accountCreated,
                      GeneralLabelInfoType.addYourFirstDevice,
                      GeneralLabelInfoType.holdPairing,
                      BagImageType.connect])
            ]
        } else {
            self.arrDisplayCellType = [
                .row([BagImageType.normal,
                      GeneralLabelInfoType.holdPairing,
                      BagImageType.connect])
            ]
        }
    }
}

// MARK: - UIButton Action(s)
extension FullDevicePairingVC {
    
    @IBAction func tapBtnIDontHaveDevice(_ sender: UIButton) {
        if !isFromHomeVC {
            SceneDelegate.shared.redirectUserToHomeScreenIfNeeded()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableView Delegate and DataSource
extension FullDevicePairingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrDisplayCellType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch arrDisplayCellType[section] {
        case .row(let arr):
            return arr.count
        case .devices(let arr):
            return arr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return arrDisplayCellType[indexPath.section].rowHeight(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch arrDisplayCellType[indexPath.section] {
        case .row(let arr):
            if let bagImageType = arr[indexPath.row] as? BagImageType {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BagTableCell", for: indexPath) as! BagTableCell
                cell.tag = indexPath.row
                cell.bagImageType = bagImageType
                return cell
            } else if let generalLabelInfoType = arr[indexPath.row] as? GeneralLabelInfoType {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralLabelInfoTableCell", for: indexPath) as! GeneralLabelInfoTableCell
                cell.tag = indexPath.row
                cell.generalLabelInfoType = generalLabelInfoType
                return cell
            }
            return UITableViewCell()
        case .devices(let arr):
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceNameTableCell", for: indexPath) as! DeviceNameTableCell
            cell.tag = indexPath.row
            cell.deviceName = arr[indexPath.row].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
            switch self.arrDisplayCellType[indexPath.section] {
            case .row:
                break
            case .devices(let arr):
                self.connectBluetoothDevice(arr[indexPath.row])
                self.performSegue(withIdentifier: "segueScanQRVC", sender: nil)
            }
        }
    }
}
