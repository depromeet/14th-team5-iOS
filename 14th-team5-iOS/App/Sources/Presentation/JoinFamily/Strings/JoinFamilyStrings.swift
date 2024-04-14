//
//  JoinFamilyStrings.swift
//  App
//
//  Created by geonhui Yu on 1/22/24.
//

import Foundation

typealias JoinFamilyStrings = String.JoinFAmily
extension String {
    enum JoinFAmily {}
}

extension JoinFamilyStrings {
    static let mainTitle: String = "\(UserDefaults.standard.nickname ?? "삐삐")님, 하나의 가족에만\n소속될 수 있어요"
    static let caption: String = "하나의 그룹에만 소속될 수 있어요."
}
