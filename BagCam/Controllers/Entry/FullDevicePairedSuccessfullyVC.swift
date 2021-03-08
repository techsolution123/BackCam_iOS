//
//  FullDevicePairedSuccessfullyVC.swift
//  BagCam
//
//  Created by Pankaj Patel on 17/02/21.
//

import UIKit
import CoreBluetooth

/// FullDevicePairedSuccessfullyVC
class FullDevicePairedSuccessfullyVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var btnFinishSetup: UIButton!
    
    /// Variable Declaration(s)
    var userInputFieldManager: UserInputFieldManager = UserInputFieldManager(.deviceName)
    
    /// Variable Declaration(s)
    var isFromHomeVC: Bool = false
    var deviceId: String = ""
    var connectedPeripheral: CBPeripheral!
    
    /// View Life Cycle
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
        if segue.identifier == "segueHomeVC" {
            
        }
    }
}

// MARK: - UI Related Method(s)
extension FullDevicePairedSuccessfullyVC {
    
    func prepareUI() {
        registerTableCell()
    }
    
    func registerTableCell() {
        self.tableView.register(UINib(nibName: "BagTableCell", bundle: nil), forCellReuseIdentifier: "BagTableCell")
        self.tableView.register(UINib(nibName: "GeneralLabelInfoTableCell", bundle: nil), forCellReuseIdentifier: "GeneralLabelInfoTableCell")
        self.tableView.register(UINib(nibName: "UserInputFiledTableCell", bundle: nil), forCellReuseIdentifier: "UserInputFiledTableCell")
    }
}

// MARK: - UIButton Action(s)
extension FullDevicePairedSuccessfullyVC {
    
    @IBAction func tapBtnFinishSetup(_ sender: UIButton) {
        let value = self.userInputFieldManager.isValidData()
        if value.valid {
            /// WebCall(s)
            self.webAddDeviceInfo()
        } else {
            userInputFieldManager.arrUserInputFieldModel[value.index].isValid = false
            userInputFieldManager.arrUserInputFieldModel[value.index].errorMessage = value.error
            /// Reloading tableView in main thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableView Delegate and DataSource
extension FullDevicePairedSuccessfullyVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInputFieldManager.arrUserInputFieldModel.count + 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 156
        } else if indexPath.row == 1 {
            return 75
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BagTableCell", for: indexPath) as! BagTableCell
            cell.tag = indexPath.row
            cell.bagImageType = .normal
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralLabelInfoTableCell", for: indexPath) as! GeneralLabelInfoTableCell
            cell.tag = indexPath.row
            cell.generalLabelInfoType = .devicePaired
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInputFiledTableCell", for: indexPath) as! UserInputFiledTableCell
        cell.parentVC = self
        cell.tag = indexPath.row - 2
        cell.userInputFieldManager = self.userInputFieldManager
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - WebCall(s)
extension FullDevicePairedSuccessfullyVC {
    
    func webAddDeviceInfo() {
        var params: [String: Any] = self.userInputFieldManager.paramDict()
        params["user_id"] = _user.id
        params["device_id"] = self.deviceId
        self.showCentralSpinner()
        Webservice.shared.request(for: .addDevice, param: params) { [weak self] (status, json, error) in
            guard let self = self else {
                return
            }
            self.hideCentralSpinner()
            if status == .success, let _ = json as? [String: Any] {
                DispatchQueue.main.async {
                    if !self.isFromHomeVC {
                        /// Redirecting user to Home Screen
                        SceneDelegate.shared.redirectUserToHomeScreenIfNeeded()
                    } else {
                        self.performSegue(withIdentifier: "segueHomeVC", sender: nil)
                    }
                }
            } else {
                self.showError(data: json)
            }
        }
    }
}
