//
//  NSItemProvider+Ext.swift
//  Core
//
//  Created by Kim dohyun on 12/28/23.
//

import Foundation


extension NSItemProvider {
    public func didSelectProfileImageWithProcessing(photo: Data, error: Error?) {
        let userInfo: [AnyHashable: Any] = ["selectImage": photo, "error": error as Any]
        NotificationCenter.default.post(name: .PHPickerAssetsDidFinishPickingProcessingPhotoNotification, object: nil, userInfo: userInfo)
        
    }
}
