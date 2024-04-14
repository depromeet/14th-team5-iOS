//
//  CalenderCell.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

typealias CalendarStrings = String.Calendar
extension String {
    enum Calendar {}
}

extension String.Calendar {
    static let mainTitle: String = "추억 캘린더"
    static let infoText: String = "모두가 참여한 날과 업로드한 사진 수로\n이 달의 친밀도를 측정합니다"
    static let allFamilyUploadedText: String = "우리 가족 모두가 사진을 올린 날"
}
