//
//  ParentVC.swift
//  BagCam
//
//  Created by Kevin Shah on 12/02/21.
//

import UIKit

/// ParentVC
class ParentVC: UIViewController {
    
    /// @IBOutlet(s)
    @IBOutlet weak var lblNavTitle: UILabel?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// Variable Declaration(s)
    var customIndicator : ActivityIndicator?
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareParentUI()
    }
    
    deinit {
        print("Deallocated: \(self.classForCoder)")
    }
}

// MARK: - UI Related Method(s)
extension ParentVC {
    
    func prepareParentUI() {
        print("Allocated: \(self.classForCoder)")
    }
    
    func presentDummyController() {
        let story: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let destVC = story.instantiateViewController(identifier: "ViewController")
        destVC.modalPresentationStyle = .fullScreen
        self.present(destVC, animated: true, completion: nil)
    }
}

// MARK: - UIButton Action(s)
extension ParentVC {
    
    @IBAction func tapParentBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapParentBtnDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Alert Related Method(s)
extension ParentVC {
    
    func showSimpleAlert(_ message: String, completion: (() -> ())? = nil) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                completion?()
            })
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Show API Error
extension ParentVC {
    
    func showError(data: Any?,yPos: CGFloat = 20) {
        if let dict = data as? NSDictionary {
            if let msg = dict["message"] as? String {
                if !msg.isEmpty {
                    self.showSimpleAlert(msg)
                }
            } else if let arrStr = dict["message"] as? [String] {
                let msg = arrStr.joined(separator: "\n")
                if !msg.isEmpty {
                    self.showSimpleAlert(msg)
                }
            }
        } else {
            self.showSimpleAlert(kInternalError)
        }
    }
}

// MARK:- Activity Indicator
extension ParentVC {
    
    func showCentralSpinner(_ userEnabled : Bool = false, message: String = "LOADING", inView: UIView? = nil) {
        DispatchQueue.main.async {
            if let _ = self.customIndicator {
                self.customIndicator?.hide()
            }
            self.view.isUserInteractionEnabled = userEnabled
            self.customIndicator = ActivityIndicator.intance(message)
            if let customHud = self.customIndicator {
                if let kView = inView {
                    kView.addSubview(customHud)
                }
                self.view.window?.addSubview(customHud)
            }
            self.customIndicator?.show(message)
        }
    }
    
    func hideCentralSpinner() {
        DispatchQueue.main.async {
            self.view?.isUserInteractionEnabled = true
            self.customIndicator?.hide()
        }
    }
}
