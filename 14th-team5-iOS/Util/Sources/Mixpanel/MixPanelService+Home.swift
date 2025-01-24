//
//  MixPanelService+Home.swift
//  Core
//
//  Created by geonhui Yu on 1/20/24.
//

import Foundation
import Mixpanel

extension MPEvent {
    public enum Home: String, MixpanelTrackable {
        case shareLink = "Click_ShareLink_Home"
        case cameraTapped = "Click_btn_Camera"
        
        public func track(with properties: Encodable?) {
            MP.mainInstance().track(event: self.rawValue, properties: properties?.asMixpanelDictionary())
            debugPrint("[Bibbi - Mixpanel - Home - \(self.rawValue)")
        }
    }
}
