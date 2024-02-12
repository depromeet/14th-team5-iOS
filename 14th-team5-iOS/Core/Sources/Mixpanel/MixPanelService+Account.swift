//
//  MixPanelService+Account.swift
//  Core
//
//  Created by geonhui Yu on 1/21/24.
//

import Foundation

extension MPEvent {
    public enum Account: String, MixpanelTrackable {
        case viewLogin = "View_Login"
        case allowNotification = "Click_Allow_Notification"
        case creatGroup = "Click_Create_NewGroup_1"
        case creatGroupFinished = "Click_Create_NewGroup_2"
        case invitedGroup = "Click_Enter_Group_1"
        case invitedGroupFinished = "Click_Enter_Group_2"
        case leaveGroup = "Click_LeaveGroup"
        case withdrawl = "Click_Withdrawal"
        
        public func track(with properties: Encodable?) {
            MP.mainInstance().track(event: self.rawValue, properties: properties?.asMixpanelDictionary())
            debugPrint("[Bibbi - Mixpanel - Account - \(self.rawValue)")
        }
    }
}
