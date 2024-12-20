//
//  BBEventAnalyticsLog.swift
//  Core
//
//  Created by 김도현 on 12/19/24.
//

import Foundation

public enum BBEventAnalyticsLog: BBAnalyticsLogType  {
    case viewPage(pageName: PageName)
    case clickAccountButton(entry: AccountButtonEntry)
    case clickFamilyButton(entry: FamilyButtonEntry)
    case clickCameraButton(entry: CameraButtonEntry)
}


public extension BBEventAnalyticsLog {
    enum PageName: String, BBAnalyticsLogParametable {
        case main
        case calendar = "calendar"
        case camera = "camera"
        case cameraDetail = "camera_detail"
        case familyManagement = "family_management"
        case familyGroupNameSetting = "family_group_name_setting"
        case postDetail = "post_detail"
        case profile
        case setting
        case resign
        
        public var description: String {
            self.rawValue
        }
    }
    
    enum AccountButtonEntry: String, BBAnalyticsLogParametable {
        case profileImageEdit = "profile_image_edit"
        case profileNickNameEdit = "profile_nickname_edit"
        case logout
        case familyResign = "family_resign"
        case resign
        
        
        public var description: String {
            self.rawValue
        }
    }
    
    enum FamilyButtonEntry: String, BBAnalyticsLogParametable {
        case createFamilyGroup = "create_family_group"
        case familyNameSetting = "family_name_setting"
        case inviteFamily = "invite_family"
        
        
        public var description: String {
            self.rawValue
        }
    }
    
    enum CameraButtonEntry: String, BBAnalyticsLogParametable {
        case shutter
    }
    
}
