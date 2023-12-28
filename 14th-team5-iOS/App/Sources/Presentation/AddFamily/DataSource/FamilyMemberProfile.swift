//
//  FamiliyMemeberProfileModel.swift
//  App
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Domain
import RxDataSources

public struct SectionOfFamilyMemberProfile {
    public var items: [Item]
}

extension SectionOfFamilyMemberProfile: SectionModelType {
    public typealias Item = FamilyMemberProfileResponse
    
    public init(original: SectionOfFamilyMemberProfile, items: [Item]) {
        self = original
        self.items = items
    }
}

extension SectionOfFamilyMemberProfile {
    static func generateTestData() -> SectionOfFamilyMemberProfile {
        var items: [SectionOfFamilyMemberProfile.Item] = []

        let memberIds = ["KKW", "KDH", "MKM", "UKH"]
        let names = ["김건우", "김도현", "마경미", "유건희"]
        let imageUrls = [
            "https://cdn.pixabay.com/photo/2023/11/20/13/48/butterfly-8401173_1280.jpg",
            nil,
            "https://cdn.pixabay.com/photo/2023/11/26/08/27/leaves-8413064_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/09/03/17/00/chives-8231068_1280.jpg"
        ]
        
        (0...3).forEach {
            let item = FamilyMemberProfileResponse(
                memberId: memberIds[$0],
                name: names[$0],
                imageUrl: imageUrls[$0]
            )
            items.append(item)
        }
        
        return SectionOfFamilyMemberProfile(items: items)
    }
}
