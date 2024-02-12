//
//  MixPanelService+Camera.swift
//  Core
//
//  Created by geonhui Yu on 1/21/24.
//

import Foundation

extension MPEvent {
    public enum Camera: String, MixpanelTrackable {
        case photoText = "Click_PhotoText"
        case uploadPhoto = "Click_UploadPhoto"
        
        public func track(with properties: Encodable?) {
            MP.mainInstance().track(event: self.rawValue, properties: properties?.asMixpanelDictionary())
            debugPrint("[Bibbi - Mixpanel - Camera - \(self.rawValue)")
        }
    }
}
