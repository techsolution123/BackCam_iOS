//
//  ScanQRVC.swift
//  BagCam
//
//  Created by Pankaj Patel on 23/02/21.
//

import UIKit
import AVKit
import CoreBluetooth

/// ScanQRVC
class ScanQRVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var btnHelpMeFindTheCode: UIButton!
    
    /// Variable Declaration(s)
    lazy var objOfQRScanner: QRScanner = {
        return QRScanner(self.cameraPreviewView)
    }()
    var scannerTargetView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(named: "ic_scanTarget"))
        imageView.frame = .zero
        return imageView
    }()
    var isControllerPushed: Bool = false
    
    /// Carried Variable
    var isFromHomeVC: Bool = false
    var connectedPeripheral: CBPeripheral!
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isControllerPushed = false
        objOfQRScanner.startScanning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        objOfQRScanner.stopScanning()
    }
    
    // Sending data or navigating to another screen
    ///
    /// - Parameters:
    ///   - segue: segue identifier can be multiple
    ///   - sender: can be nil or carried the content data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFullDevicePairedSuccessfullyVC" {
            let destVC = segue.destination as! FullDevicePairedSuccessfullyVC
            destVC.isFromHomeVC = self.isFromHomeVC
            destVC.connectedPeripheral = self.connectedPeripheral
            destVC.security_code = sender as! String
        }
    }
}

// MARK: - UI Related Method(s)
extension ScanQRVC {
    
    func prepareUI() {
        preparingQRScanner()
        cameraPreviewView.addSubview(scannerTargetView)
    }
    
    func preparingQRScanner() {
        DispatchQueue.main.async {
            self.objOfQRScanner.stateBlock = { [weak self] (state) in
                guard let self = self else {
                    return
                }
                switch state {
                case .detected(let arrFirstQR):
                    print("Found")
                    if !self.isControllerPushed {
                        self.isControllerPushed = true
                        self.objOfQRScanner.stopScanning()
                        let obj0 = arrFirstQR[0] as! AVMetadataMachineReadableCodeObject
                        let security_code: String = obj0.stringValue ?? ""
                        print("QRCode name: \(security_code)")
                        let obj1 = arrFirstQR[1] as! AVMetadataObject
                        self.scannerTargetView.frame = obj1.bounds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            self.performSegue(withIdentifier: "segueFullDevicePairedSuccessfullyVC", sender: security_code)
                        }
                    }
                case .notFound:
                    print("No Found")
                    self.scannerTargetView.frame = .zero
                case .error(let err):
                    print(err)
                    self.scannerTargetView.frame = .zero
                }
            }
        }
    }
}

// MARK: - UIButton Action(s)
extension ScanQRVC {
    
    @IBAction func tapBtnHelpMeFindTheCode(_ sender: UIButton) {
        
    }
}
