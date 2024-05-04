//
//  BannerResponse.swift
//  Domain
//
//  Created by 김건우 on 1/26/24.
//

import UIKit

public struct BannerEntity {
    public var familyTopPercentage: Int
    public var allFammilyMembersUploadedDays: Int
    public var familyLevel: Int
    public var bannerImage: UIImage
    public var bannerString: String
    public var bannerColor: UIColor
    
    public init(
        familyTopPercentage: Int,
        allFamilyMembersUploadedDays: Int,
        familyLevel: Int,
        bannerImage: UIImage,
        bannerString: String,
        bannerColor: UIColor
    ) {
        self.familyTopPercentage = familyTopPercentage
        self.allFammilyMembersUploadedDays = allFamilyMembersUploadedDays
        self.familyLevel = familyLevel
        self.bannerImage = bannerImage
        self.bannerString = bannerString
        self.bannerColor = bannerColor
    }
}
