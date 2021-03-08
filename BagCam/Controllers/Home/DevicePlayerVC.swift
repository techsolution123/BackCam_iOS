//
//  DevicePlayerVC.swift
//  BagCam
//
//  Created by Pankaj Patel on 22/02/21.
//

import UIKit
import AVKit

/// DevicePlayerVC
class DevicePlayerVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var videoPreview: UIView! {
        didSet {
            videoPreview.backgroundColor = .black
        }
    }
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var videoControllerView: UIVisualEffectView!
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnShield: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    
    /// Variable Declaration(s)
    var videoPlayer: AVPlayer!
    var videoPlayerLayer: AVPlayerLayer!
    var isVideoControllerHidden: Bool = true {
        didSet {
            self.videoControllerView.isHidden = isVideoControllerHidden
            self.imgV.isHidden = !isVideoControllerHidden
        }
    }
    var isVideoPlaying: Bool = false {
        didSet {
            isVideoPlaying ? self.videoStart() : self.videoStop()
            let imageName: String = isVideoPlaying ? "ic_videoPause" : "ic_videoPlay"
            self.btnPlayPause.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    /// Carried Variable
    var deviceListModel: DeviceListModel!
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
        videoPlayerLayer?.frame = self.videoPreview.frame
        videoPlayerLayer?.videoGravity = .resizeAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.DeviceOrientation.lockOrientation(.landscape, andRotateTo: .landscapeRight)
        isVideoPlaying = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isVideoPlaying = false
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}

// MARK: - UI Related Method(s)
extension DevicePlayerVC {
    
    func prepareUI() {
        self.imgV.isHidden = true
        prepareVideoPlayer()
    }
    
    func prepareVideoPlayer() {
        self.view.layoutIfNeeded()
        
        let url: URL = deviceListModel.deviceVideoUrl!
        videoPlayer = AVPlayer(url: url)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        videoPlayerLayer.frame = self.videoPreview.frame
        videoPlayerLayer.videoGravity = .resizeAspectFill
        videoPreview.layer.insertSublayer(videoPlayerLayer, at: 0)
    }
    
    func videoStart() {
//        isVideoControllerHidden = false
        videoPlayer?.play()
    }
    
    func videoStop() {
//        isVideoControllerHidden = true
        videoPlayer?.pause()
    }
}

// MARK: - UIButton Action(s)
extension DevicePlayerVC {
    
    @IBAction func tapBtnMic(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnSound(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnPlayPause(_ sender: UIButton) {
        isVideoPlaying = !isVideoPlaying
    }
    
    @IBAction func tapBtnShield(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnCamera(_ sender: UIButton) {
        
    }
}
