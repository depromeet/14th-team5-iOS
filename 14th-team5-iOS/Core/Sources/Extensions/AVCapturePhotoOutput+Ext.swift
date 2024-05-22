//
//  AVCapturePhotoOutput+Ext.swift
//  Core
//
//  Created by Kim dohyun on 12/27/23.
//

import Foundation

import AVFoundation


@available(*, deprecated, message: "중복 이벤트 문제로 ReactorKit을 사용해주세요")
extension AVCapturePhotoOutput {
    public func photoOutputDidFinshProcessing(photo: Data, error: Error?) {
        let userInfo: [AnyHashable: Any] = ["photo": photo, "error": error as Any]
        print("photoOutputDidFinshProcessing: \(photo)")
        NotificationCenter.default.post(name: .AVCapturePhotoOutputDidFinishProcessingPhotoNotification, object: nil, userInfo: userInfo)
    }
    
}
