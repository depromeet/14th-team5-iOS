//
//  OnBoardingStrings.swift
//  App
//
//  Created by geonhui Yu on 12/10/23.
//

import Foundation

typealias OnBoardingStrings = String.OnBoarding
extension String {
    enum OnBoarding {}
}

extension OnBoardingStrings {
    static let normalButtonTitle: String = "알림 허용하고 그룹 생성하기"
    static let inviteButtonTitle: String = "알림 허용하고 입장하기"
    
    static let push: String = "매일 아침 10시 알림이 울리면\n가족에게 1장의 사진을 보내세요"
    static let widget: String = "홈 화면에 삐삐 위젯을 추가해\n가족의 일상을 확인하세요"
    static let mission: String = "가족 절반이 생존 신고하면,\n새로운 미션 사진을 찍을 수 있어요!"
    static let permission: String = "하루에 두 번 오는 생존 알림,\n놓치지 않으려면 꼭 허용하세요!"
}
