//
//  MainNightData.swift
//  Domain
//
//  Created by 마경미 on 07.05.24.
//

import UIKit

import DesignSystem

public enum Rank {
    case none
    case first
    case second
    case third
    
    public var borderColor: UIColor {
        switch self {
        case .none: return .gray600
        case .first: return .mainYellow
        case .second: return .graphicGreen
        case .third: return .graphicOrange
        }
    }
    
    public var badgeImage: UIImage {
        switch self {
        case .first: return DesignSystemAsset.rank1.image
        case .second: return DesignSystemAsset.rank2.image
        case .third: return DesignSystemAsset.rank3.image
        default: fatalError("Rank Not Founded")
        }
    }
    
    public var grayBadgeImage: UIImage {
        switch self {
        case .first: return DesignSystemAsset.emptyRank1.image
        case .second: return DesignSystemAsset.emptyRank2.image
        case .third: return DesignSystemAsset.emptyRank3.image
        default: fatalError("Rank Not Founded")
        }
    }
}

public struct RankerData {
    public let imageURL: String?
    public let name: String
    public let survivalCount: Int
    
    public init(imageURL: String?, name: String, survivalCount: Int) {
        self.imageURL = imageURL
        self.name = name
        self.survivalCount = survivalCount
    }
}

public struct FamilyRankData {
    public let month: Int
    public let recentPostDate: String?
    public let firstRanker: RankerData?
    public let secondRanker: RankerData?
    public let thirdRanker: RankerData?
    
    public init(month: Int, recentPostDate: String?, firstRanker: RankerData?, secondRanker: RankerData?, thirdRanker: RankerData?) {
        self.month = month
        self.recentPostDate = recentPostDate
        self.firstRanker = firstRanker
        self.secondRanker = secondRanker
        self.thirdRanker = thirdRanker
    }
}

extension FamilyRankData {
    public static var empty: FamilyRankData {
        return .init(month: 0, recentPostDate: nil, firstRanker: nil, secondRanker: nil, thirdRanker: nil)
    }
}

public struct NightMainViewEntity {
    public let familyName: String?
    public let mainFamilyProfileDatas: [FamilyMemberProfileEntity]
    public let familyRankData: FamilyRankData
    
    public init(
        familyName: String?,
        mainFamilyProfileDatas: [FamilyMemberProfileEntity],
        familyRankData: FamilyRankData
    ) {
        self.familyName = familyName
        self.mainFamilyProfileDatas = mainFamilyProfileDatas
        self.familyRankData = familyRankData
    }
}
