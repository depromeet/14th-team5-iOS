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
    
    static let push: String = "매일 낮 12시, 알림을 받으면\n가족에게 사진을 보내세요"
    static let widget: String = "홈 화면 위젯으로\n가족의 일상을 한 눈에 확인해요"
    static let permission: String = "하루에 오직 두 번 오는 알림,\n놓치지 않으려면 꼭 허용하세요!"
}
