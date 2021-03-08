//
//  DeviceListTableCell.swift
//  BagCam
//
//  Created by Pankaj Patel on 19/02/21.
//

import UIKit
import AVKit

/// AVPlayerLayer
class BGVideoLayer: AVPlayerLayer {
    
    init(_ player: AVPlayer) {
        super.init()
        self.player = player
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// DeviceListTableCell
class DeviceListTableCell: UITableViewCell {
    
    /// @IBOutlet(s)
    @IBOutlet weak var lblVideoTime: UILabel!
    @IBOutlet weak var btnFullVideoScreen: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imgVVideoThumbnail: UIImageView!
    @IBOutlet weak var btnGoLive: UIButton!
    
    /// Video Control(s)
    @IBOutlet weak var videoControllerView: UIVisualEffectView!
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnShield: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    
    /// VideoError
    @IBOutlet weak var videoErrorView: UIView!
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNetwork: UIButton!
    @IBOutlet weak var btnCloud: UIButton!
    @IBOutlet weak var btnBattery: UIButton!
    @IBOutlet weak var btnNumberOfEvent: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    
    /// Variable Declaration(s)
    weak var parentHomeVC: HomeVC!
    var videoPlayer: AVPlayer!
    var videoPlayerLayer: BGVideoLayer!
    
    var isVideoControllerHidden: Bool = true {
        didSet {
            self.videoControllerView.isHidden = isVideoControllerHidden
            self.btnFullVideoScreen.isHidden = isVideoControllerHidden
            self.btnGoLive.isHidden = !isVideoControllerHidden
            self.imgVVideoThumbnail.isHidden = !isVideoControllerHidden
            self.lblVideoTime.isHidden = false
            deviceListModel.isVideoControllerHidden = isVideoControllerHidden
            
            videoErrorView.isHidden = deviceListModel.isVideoErrorViewByDefaultHidden
            if deviceListModel.isVideoErrorViewByTapToHidden {
                self.videoControllerView.isHidden = true
                self.btnFullVideoScreen.isHidden = true
                self.btnGoLive.isHidden = true
                self.lblVideoTime.isHidden = false
            }
        }
    }
    
    var deviceListModel: DeviceListModel! {
        didSet {
            imgVVideoThumbnail.image = deviceListModel.videoThumbnailImage
            lblVideoTime.text = deviceListModel.time_ago
            lblTitle.text = deviceListModel.device_name
            btnNumberOfEvent.setTitle("\(deviceListModel.number_of_event) EVENTS", for: .normal)
            isVideoControllerHidden = deviceListModel.isVideoControllerHidden
            
            /// https://b-117b36f5.kinesisvideo.us-west-2.amazonaws.com/hls/v1/getHLSMasterPlaylist.m3u8?SessionToken=CiCkbM59EwKlZossQSA1ed-YM5OJZC6nC4HjCOfbJMy5jhIQDhmHTiS71qV3rBhmoW_nuhoZwHKCYM02EEewXPjMOfSp_jk8Yd36mbWCgCIgplpsHBwNa1nzaOXCe0zobwb6Gb6BQVLhlj-VDVnThZA~
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        videoPlayerLayer?.frame = self.videoView.frame
        videoPlayerLayer?.videoGravity = .resizeAspectFill
    }
}

// MARK: - UIButton Action(s)
extension DeviceListTableCell {
    
    func videoStart() {
        isVideoControllerHidden = false
        deviceListModel.isVideoErrorViewByTapToHidden = false
        
        if let bgVideoLayer = videoView.layer.sublayers?.first(where: { (layer) -> Bool in
            if let _ = layer as? BGVideoLayer {
                return true
            }
            return false
        }) {
            bgVideoLayer.removeFromSuperlayer()
        }
        
        let url: URL = deviceListModel.deviceVideoUrl!
        videoPlayer = AVPlayer(url: url)
        videoPlayerLayer = BGVideoLayer(videoPlayer)
        videoPlayerLayer.frame = self.videoView.frame
        videoPlayerLayer.videoGravity = .resizeAspectFill
        
        videoView?.layer.insertSublayer(videoPlayerLayer, at: 0)
        videoPlayer?.play()
    }
    
    func videoStop() {
        isVideoControllerHidden = true
        videoPlayer?.pause()
        videoPlayerLayer?.removeFromSuperlayer()
    }
    
    @IBAction func tapBtnFullVideoScreen(_ sender: UIButton) {
        DispatchQueue.main.async {
            if self.deviceListModel.isDeviceVideoUrlIsValid {
                self.parentHomeVC.performSegue(withIdentifier: "segueDevicePlayerVC", sender: self.deviceListModel)
            }
        }
        self.videoStop()
    }
    
    @IBAction func tapBtnGoLive(_ sender: UIButton) {
        if deviceListModel.isDeviceVideoUrlIsValid {
            self.videoStart()
        } else {
            deviceListModel.isVideoErrorViewByDefaultHidden = false
            deviceListModel.isVideoErrorViewByTapToHidden = true
            /// Reloading tableView in main thread.
            DispatchQueue.main.async {
                self.parentHomeVC.tableView.reloadData()
            }
        }
    }
    
    @IBAction func tapBtnMic(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnSound(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnPlayPause(_ sender: UIButton) {
        self.videoStop()
    }
    
    @IBAction func tapBtnShield(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnCamera(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnNetwork(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnCloud(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnBattery(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnNumberOfEvent(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnSetting(_ sender: UIButton) {
        self.parentHomeVC.performSegue(withIdentifier: "segueDeviceSettingVC", sender: nil)
    }
}
