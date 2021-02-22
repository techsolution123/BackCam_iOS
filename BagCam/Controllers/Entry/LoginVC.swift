//
//  LoginVC.swift
//  BagCam
//
//  Created by Kevin Shah on 12/02/21.
//

import UIKit

/// LoginVC
class LoginVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    /// Variable Declaration(s)
    var userInputFieldManager: UserInputFieldManager = UserInputFieldManager(.login)
    
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
        if segue.identifier == "segueForgotPasswordVC" {
            
        }
    }
    
    @IBAction func unwindLogin(_ segue: UIStoryboardSegue) {
        
    }
}

// MARK: - UI Related Method(s)
extension LoginVC {
    
    func prepareUI() {
        registerTableCell()
    }
    
    func registerTableCell() {
        self.tableView.register(UINib(nibName: "TitleTableCell", bundle: nil), forCellReuseIdentifier: "TitleTableCell")
        self.tableView.register(UINib(nibName: "UserInputFiledTableCell", bundle: nil), forCellReuseIdentifier: "UserInputFiledTableCell")
    }
}

// MARK: - UIButton Action(s)
extension LoginVC {
    
    @IBAction func tapBtnLogin(_ sender: UIButton) {
        let value = self.userInputFieldManager.isValidData()
        if value.valid {
            /// WebCall(s)
            self.webLogin()
        } else {
            userInputFieldManager.arrUserInputFieldModel[value.index].isValid = false
            userInputFieldManager.arrUserInputFieldModel[value.index].errorMessage = value.error
            /// Reloading tableView in main thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func tapBtnForgotPassword(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueForgotPasswordVC", sender: nil)
    }
}

// MARK: - UITableView Delegate, DataSource
extension LoginVC: UITableViewDelegate, UITableViewDataSource {
    
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
extension LoginVC {
    
    func webLogin() {
        showCentralSpinner()
        Webservice.shared.request(for: .login, param: self.userInputFieldManager.paramDict()) { [weak self] (statusCode, json, error) in
            guard let self = self else {
                return
            }
            self.hideCentralSpinner()
            if statusCode == .success, let jsonDict = json as? [String: Any] {
                if let dataDict = jsonDict["data"] as? [String: Any] {
                    /// Storing user data into core data
                    User.createOrUpdateUser(dataDict)
                    DispatchQueue.main.async {
                        SceneDelegate.shared.redirectUserToHomeScreenIfNeeded()
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
