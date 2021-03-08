//
//  QRScanner.swift
//  QRScanner
//
//  Created by Pankaj Patel on 08/10/19.
//  Copyright © 2019 Pankaj Patel. All rights reserved.
//

import UIKit
import AVKit

/// QRScannerState, This will define the state of QRScanner.
enum QRScannerState {
    /*
     `detected first: [0] as! AVMetadataMachineReadableCodeObject, [1] as! AVMetadataObject
     `detected second: [0] as! AVMetadataMachineReadableCodeObject, [1] as! AVMetadataObject
    */
    case detected(_ first: [Any])
    case notFound
    case error(_ msg: String)
}

/// QRScanner
class QRScanner: NSObject {
    
    /// Variable Declaration(s)
    fileprivate var arrSupportedCodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    fileprivate var viewPreviewLayer: AVCaptureVideoPreviewLayer!
    fileprivate var captureSession: AVCaptureSession = AVCaptureSession()
    
    /// onView will be responsible for previewing camera for QRDetection
    fileprivate var onView: UIView!
    
    /// isCameraReadyForDetection, if everything went flag will be state as true
    fileprivate var isCameraReadyForDetection: Bool = false
    
    /// stateBlock will define scanning state
    var stateBlock: ((QRScannerState) -> ())?
    
    init(_ onView: UIView) {
        self.onView = onView
        super.init()
        initializingCamera()
    }
}

// MARK: - Scanning Related Method(s)
extension QRScanner {
    
    fileprivate func initializingCamera() {
        /// Getting the back camera
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            stateBlock?(.error("Failed to get the camera device"))
            return
        }
        do {
            /// Instance of device input from capture device
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            /// Setting deviceInput into captureSession
            captureSession.addInput(deviceInput)
            /// Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            /// Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = arrSupportedCodeTypes
        } catch let err {
            /// If error, don't continue any more
            stateBlock?(.error(err.localizedDescription))
            return
        }
        onView.layoutIfNeeded()
        /// Initialize viewPreviewLayer using captureSession
        viewPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        viewPreviewLayer.videoGravity = .resizeAspectFill
        viewPreviewLayer.frame = onView.layer.bounds
        /// Adding viewPreviewLayer as a subLayer in onView for the displaying camera content
        onView.layer.addSublayer(viewPreviewLayer)
        isCameraReadyForDetection = true
    }
    
    func startScanning() {
        guard isCameraReadyForDetection else {
            stateBlock?(.error("Error: At initialize time"))
            return
        }
        captureSession.startRunning()
    }
    
    func stopScanning() {
        captureSession.stopRunning()
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRScanner: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print(metadataObjects.count)
        guard metadataObjects.count == 1 else {
            stateBlock?(.notFound)
            return
        }
        let arrMetaDataObj = metadataObjects as! [AVMetadataMachineReadableCodeObject]
        var qr1: [Any] = []
        for value in arrMetaDataObj {
            if arrSupportedCodeTypes.contains(value.type) {
                /// If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
                let barCodeObject = viewPreviewLayer.transformedMetadataObject(for: value)
                qr1 = [value, barCodeObject!]
            }
        }
        if !qr1.isEmpty {
            stateBlock?(.detected(qr1))
        } else {
            stateBlock?(.notFound)
        }
    }
}
