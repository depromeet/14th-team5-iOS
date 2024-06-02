//
//  BannerResponseDTO.swift
//  Data
//
//  Created by 김건우 on 1/26/24.
//

import Domain
import DesignSystem
import UIKit

public struct BannerResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case familyTopPercentage
        case allFamilyMembersUploadedDays
        case familyLevel
        case bannerImageType
    }
    var familyTopPercentage: Int
    var allFamilyMembersUploadedDays: Int
    var familyLevel: Int
    var bannerImageType: BannerImageType
}

extension BannerResponseDTO {
    enum BannerImageType: String, Decodable {
        case skullFlag = "SKULL_FLAG"
        case aloneWalking = "ALONE_WALKING"
        case weAreFriends = "WE_ARE_FRIENDS"
        case jewelryTreasure = "JEWELRY_TREASURE"
        
        var image: UIImage {
            switch self {
            case .skullFlag:
                return DesignSystemAsset.skullFlag.image
            case .aloneWalking:
                return DesignSystemAsset.aloneWalking.image
            case .weAreFriends:
                return DesignSystemAsset.weAreFriends.image
            case .jewelryTreasure:
                return DesignSystemAsset.jewelryTreasure.image
            }
        }
        
        var color: UIColor {
            switch self {
            case .skullFlag:
                return DesignSystemAsset.graphicBlue.color
            case .aloneWalking:
                return DesignSystemAsset.graphicOrange.color
            case .weAreFriends:
                return DesignSystemAsset.graphicGreen.color
            case .jewelryTreasure:
                return DesignSystemAsset.graphicPink.color
            }
        }
        
        var string: String {
            switch self {
            case .skullFlag:
                return "남보다 못한 사이"
            case .aloneWalking:
                return "조금 서먹한 사이"
            case .weAreFriends:
                return "친구만큼 가까운 사이"
            case .jewelryTreasure:
                return "없으면 못사는 사이"
            }
        }
    }
}

extension BannerResponseDTO {
    func toDomain() -> BannerEntity {
        return .init(
            familyTopPercentage: familyTopPercentage,
            allFamilyMembersUploadedDays: allFamilyMembersUploadedDays,
            familyLevel: familyLevel,
            bannerImage: bannerImageType.image,
            bannerString: bannerImageType.string,
            bannerColor: bannerImageType.color
        )
    }
}
