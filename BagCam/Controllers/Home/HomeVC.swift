//
//  HomeVC.swift
//  BagCam
//
//  Created by Kevin Shah on 19/02/21.
//

import UIKit
import AVKit

/// HomeVC
class HomeVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var btnAddDevice: UIButton!
    
    /// Variable Declaration(s)
    var arrDeviceListModel: [DeviceListModel] = []
    
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
        if segue.identifier == "segueFullDevicePairingVC" {
            let destVC = segue.destination as! FullDevicePairingVC
            destVC.isFromHomeVC = true
        } else if segue.identifier == "segueDeviceSettingVC" {
            
        } else if segue.identifier == "segueDevicePlayerVC" {
            
        }
    }
    
    @IBAction func unwindHomeVC(_ sender: UIStoryboardSegue) {
        /// WebCall(s)
        self.webGetDeviceList(false)
    }
}

// MARK: - UI Related Method(s)
extension HomeVC {
    
    func prepareUI() {
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 60, right: 0)
        registerTableCell()
        /// WebCall(s)
        self.webGetDeviceList()
    }
    
    func registerTableCell() {
        self.tableView.register(UINib(nibName: "AddDeviceTableCell", bundle: nil), forCellReuseIdentifier: "AddDeviceTableCell")
        self.tableView.register(UINib(nibName: "DeviceListTableCell", bundle: nil), forCellReuseIdentifier: "DeviceListTableCell")
    }
    
    func presentLiveUrlStreamController() {
        /// https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8") else {
            return
        }
        let avPlayerVC: AVPlayerViewController = AVPlayerViewController()
        avPlayerVC.player = AVPlayer(url: url)
        self.present(avPlayerVC, animated: true, completion: {
            avPlayerVC.player?.play()
        })
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
        return self.arrDeviceListModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceListTableCell", for: indexPath) as! DeviceListTableCell
        cell.parentHomeVC = self
        cell.tag = indexPath.row
        cell.deviceListModel = arrDeviceListModel[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - WebCall(s)
extension HomeVC {
    
    func webGetDeviceList(_ isShowCenteralSpinner: Bool = true) {
        var params: [String: Any] = [:]
        params["user_id"] = _user.id
        if isShowCenteralSpinner {
            showCentralSpinner()
        }
        Webservice.shared.request(for: .deviceList, param: params) { [weak self] (status, json, error) in
            guard let self = self else {
                return
            }
            self.hideCentralSpinner()
            if status == .success, let jsonDict = json as? [String: Any] {
                if let arrDataDict = jsonDict["data"] as? [[String: Any]] {
                    self.arrDeviceListModel = []
                    for dataDict in arrDataDict {
                        self.arrDeviceListModel.append(DeviceListModel(dataDict))
                    }
                    /// Reloading tableView in main thread
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
