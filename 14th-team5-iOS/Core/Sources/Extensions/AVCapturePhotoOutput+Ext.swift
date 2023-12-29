//
//  AVCapturePhotoOutput+Ext.swift
//  Core
//
//  Created by Kim dohyun on 12/27/23.
//

import Foundation

import AVFoundation


extension AVCapturePhotoOutput {
    public func photoOutputDidFinshProcessing(photo: Data, error: Error?) {
        let userInfo: [AnyHashable: Any] = ["photo": photo, "error": error as Any]
        print("photoOutputDidFinshProcessing: \(photo)")
        NotificationCenter.default.post(name: .AVCapturePhotoOutputDidFinishProcessingPhotoNotification, object: nil, userInfo: userInfo)
    }
    
}
