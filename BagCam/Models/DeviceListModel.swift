//
//  DeviceListModel.swift
//  BagCam
//
//  Created by Pankaj Patel on 26/02/21.
//

import UIKit
import AVKit

/// DeviceStatus
enum DeviceStatus: String {
    
    case pending = "pending"
    case accepted = "accept"
}

/// DeviceListModel
class DeviceListModel: NSObject {
    
    var date: Date?
    var device_id: String
    var device_name: String
    var device_video: String
    var image_thumbnail: String
    var battery_percentage: String
    var number_of_event: String
    var time_ago: String
    var device_status: DeviceStatus
    
    var isVideoControllerHidden: Bool = true
    var isVideoErrorViewByDefaultHidden: Bool = true
    var isVideoErrorViewByTapToHidden: Bool = false
    
    var deviceVideoUrl: URL? {
        return URL(string: device_video)
    }
    
    var isDeviceVideoUrlIsValid: Bool {
        return (deviceVideoUrl != nil)
    }
    
    var videoThumbnailImage: UIImage?
    
    var imageUrl: URL? {
        return URL(string: image_thumbnail)
    }
    
    var tableViewReloadCompletion: (() -> ())?
    
    init(_ dict: [String: Any]) {
        date = dict.optionalDate("date")
        device_id = dict.string("device_id")
        device_name = dict.string("device_name")
        device_video = dict.string("device_video")
        image_thumbnail = dict.string("image_thumbnail")
        battery_percentage = dict.string("battery_percentage")
        number_of_event = dict.string("number_of_event")
        time_ago = dict.string("time_ago")
        device_status = DeviceStatus(rawValue: dict.string("device_status")) ?? .pending
        super.init()
        if let url = deviceVideoUrl, videoThumbnailImage == nil {
            generateThumbnail(path: url, completion: { (image) in
                self.videoThumbnailImage = image
                self.tableViewReloadCompletion?()
            })
        } else {
            videoThumbnailImage = UIImage(named: "ic_videoPlaceholder")
        }
    }
    
    func generateThumbnail(path: URL, completion: @escaping ((UIImage?) -> ())) {
        DispatchQueue.global().async {
            do {
                let asset = AVURLAsset(url: path, options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                completion(thumbnail)
            } catch let error {
                print("Error generating thumbnail: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
