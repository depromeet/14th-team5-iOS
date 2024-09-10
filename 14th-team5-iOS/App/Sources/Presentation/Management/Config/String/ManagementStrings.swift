//
//  LinkShareVC.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import UIKit

typealias ManagementStrings = String.Management
extension String {
    enum Management {}
}

extension ManagementStrings {
    
    static let mainTitle: String = "가족"
    static let inviteDescText: String = "삐삐에 가족 초대하기"
    static let invitationUrlText: String = "https://no5ing.kr/"
    static let headerTitle: String = "당신의 가족"
    static let headerCount: String = "0"
    static let sucessCopyInvitationUrlText = "링크가 복사되었어요"
    static let fetchFailInvitationUrlText = "잠시 후에 다시 시도해주세요"
    static let fetchFailFamilyText = "가족을 불러오는데 실패했어요"
    
}
