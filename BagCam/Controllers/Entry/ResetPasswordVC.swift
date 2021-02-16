//
//  ResetPasswordVC.swift
//  BagCam
//
//  Created by Kevin Shah on 15/02/21.
//

import UIKit

/// ResetPasswordVC
class ResetPasswordVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var btnResetPassword: UIButton!
    
    /// Variable Declaration(s)
    var userInputFieldManager: UserInputFieldManager = UserInputFieldManager(.resetPassword)
    
    /// Carried Variable
    var emailUserInputFieldManager: UserInputFieldManager!
    
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
        if segue.identifier == "segueLoginVC" {
            
        }
    }
}

// MARK: - UI Related Method(s)
extension ResetPasswordVC {
    
    func prepareUI() {
        registerTableCell()
    }
    
    func registerTableCell() {
        self.tableView.register(UINib(nibName: "TitleTableCell", bundle: nil), forCellReuseIdentifier: "TitleTableCell")
        self.tableView.register(UINib(nibName: "UserInputFiledTableCell", bundle: nil), forCellReuseIdentifier: "UserInputFiledTableCell")
    }
}

// MARK: - UIButton Action(s)
extension ResetPasswordVC {
    
    @IBAction func tapBtnResetPassword(_ sender: UIButton) {
        let value = self.userInputFieldManager.isValidData()
        if value.valid {
            /// WebCall(s)
            self.webResetPassword()
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
extension ResetPasswordVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInputFieldManager.arrUserInputFieldModel.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 171
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
extension ResetPasswordVC {
    
    func webResetPassword() {
        let params: [String: Any] = self.emailUserInputFieldManager.paramDict().merge(userInputFieldManager.paramDict())
        showCentralSpinner()
        Webservice.shared.request(for: .resetPassword, param: params) { [weak self] (status, json, error) in
            guard let self = self else {
                return
            }
            self.hideCentralSpinner()
            if status == .success {
                /// Navigating user to Reset Password Screen.
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueLoginVC", sender: nil)
                }
            } else {
                self.showError(data: json)
            }
        }
    }
}
