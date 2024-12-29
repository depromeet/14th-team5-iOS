//
//  MixPanelService+Family.swift
//  Core
//
//  Created by geonhui Yu on 1/21/24.
//

import Foundation

extension MPEvent {
    public enum Family: String, MixpanelTrackable {
        case shareLink = "Click_ShareLink_Family"
        
        public func track(with properties: Encodable?) {
            MP.mainInstance().track(event: self.rawValue, properties: properties?.asMixpanelDictionary())
            debugPrint("[Bibbi - Mixpanel - Family - \(self.rawValue)")
        }
    }
}
