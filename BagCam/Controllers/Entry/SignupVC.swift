//
//  SignupVC.swift
//  BagCam
//
//  Created by Pankaj Patel on 13/02/21.
//

import UIKit

/// SignupVC
class SignupVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var btnSignup: UIButton!
    
    /// Variable Declaration(s)
    var userInputFieldManager: UserInputFieldManager = UserInputFieldManager(.signup)
    
    /// Variable Declaration(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

// MARK: - UI Related Method(s)
extension SignupVC {
    
    func prepareUI() {
        registerTableCell()
    }
    
    func registerTableCell() {
        self.tableView.register(UINib(nibName: "TitleTableCell", bundle: nil), forCellReuseIdentifier: "TitleTableCell")
        self.tableView.register(UINib(nibName: "UserInputFiledTableCell", bundle: nil), forCellReuseIdentifier: "UserInputFiledTableCell")
    }
}

// MARK: - UIButton Action(s)
extension SignupVC {
    
    @IBAction func tapBtnSignup(_ sender: UIButton) {
        let value = self.userInputFieldManager.isValidData()
        if value.valid {
            /// WebCall(s)
            self.webSignup()
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

// MARK: - UITableView Delegate, DataSource
extension SignupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInputFieldManager.arrUserInputFieldModel.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 181
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            /// TitleTableCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableCell", for: indexPath) as! TitleTableCell
            cell.tag = indexPath.row
            cell.userInputFieldType = userInputFieldManager.type
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInputFiledTableCell", for: indexPath) as! UserInputFiledTableCell
        cell.parentVC = self
        cell.tag = indexPath.row - 1
        cell.userInputFieldManager = self.userInputFieldManager
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - WebCall(s)
extension SignupVC {
    
    func webSignup() {
        showCentralSpinner()
        Webservice.shared.request(for: .signup, param: userInputFieldManager.paramDict()) { [weak self] (status, json, error) in
            guard let self = self else {
                return
            }
            self.hideCentralSpinner()
            if status == .success, let jsonDict = json as? [String: Any] {
                if let dataDict = jsonDict["data"] as? [String: Any] {
                    /// Storing user data into core data
                    User.createOrUpdateUser(dataDict)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "segueFullDevicePairingVC", sender: nil)
                    }
                } else {
                    self.showError(data: json)
                }
            } else {
                self.showError(data: json)
            }
        }
    }
}
