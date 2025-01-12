//
//  HomeStringLiterals.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation

typealias HomeStrings = String.Home
extension String {
    enum Home {
        enum Timer {
            static let notTime = "00:00:00"
        }
        enum Description {
            static let standard = "매일 12시부터 24시까지 사진을 업로드할 수 있어요"
            static let allUploaded = "우리 가족 모두가 사진을 올린 날🎉"
            static let oneHourLeft = "시간이 얼마 남지 않았어요!"
        }
        enum InviteFamily {
            static let subTitle = "이런, 아직 아무도 없군요!"
            static let title = "가족 초대하기"
        }
    }
}
