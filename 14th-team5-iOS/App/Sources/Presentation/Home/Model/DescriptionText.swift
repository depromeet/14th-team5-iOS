//
//  DescriptionText.swift
//  App
//
//  Created by 마경미 on 11.05.24.
//

import UIKit

import DesignSystem

enum Description {
    case survivalNone
    case survivalFull
    case missionNone(Int)
    case mission(String)
    case missionFull
    
    var text: String {
        switch self {
        case .survivalNone:
            return "매일 10-24시에 사진 한 장을 올려요"
        case .survivalFull:
            return "우리 가족 모두가 사진을 올린 날"
        case .missionNone(let count):
            return "가족 중 \(count)명만 더 올리면 미션 열쇠를 받아요!"
        case .mission(let string):
            return string
        case .missionFull:
            return "우리 가족 모두가 미션을 성공한 날"
        }
    }
    
    var image: UIImage {
        switch self {
        case .survivalNone, .mission:
            return DesignSystemAsset.smile.image
        case .missionFull, .survivalFull:
            return DesignSystemAsset.congratulation.image
        case .missionNone:
            return DesignSystemAsset.key.image
        }
    }
}
