//
//  Notification+Ext.swift
//  Core
//
//  Created by Kim dohyun on 12/27/23.
//

import Foundation


extension Notification.Name {
    public static let AVCapturePhotoOutputDidFinishProcessingPhotoNotification: Notification.Name = Notification.Name("AVCapturePhotoOutputDidFinishProcessingPhotoNotification")
    public static let PHPickerAssetsDidFinishPickingProcessingPhotoNotification: Notification.Name = Notification.Name("PHPickerAssetsDidFinishPickingProcessingPhotoNotification")
    public static let AppVersionsCheckWithRedirectStore = Notification.Name("AppVersionsCheckWithRedirectStore")
    public static let UserAccountDeleted = Notification.Name("UserAccountDeleted")
}
