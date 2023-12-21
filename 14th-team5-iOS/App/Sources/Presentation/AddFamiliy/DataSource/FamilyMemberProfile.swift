//
//  FamiliyMemeberProfileModel.swift
//  App
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Domain
import RxDataSources

public struct FamilyMemeberProfile {
    var memberId: String
    var name: String
    var imageUrl: String?
}

public struct SectionOfFamilyMemberProfile {
    public var items: [Item]
}

extension SectionOfFamilyMemberProfile: SectionModelType {
    public typealias Item = FamilyMemeberProfile
    
    public init(original: SectionOfFamilyMemberProfile, items: [FamilyMemeberProfile]) {
        self = original
        self.items = items
    }
}

extension SectionOfFamilyMemberProfile {
    static func toSectionModel(_ familiyMember: PaginationResponseFamilyMemberProfile) -> [SectionOfFamilyMemberProfile] {
        let items = familiyMember.results.map {
            FamilyMemeberProfile(
                memberId: $0.memberId,
                name: $0.name,
                imageUrl: $0.imageUrl
            )
        }
        return [SectionOfFamilyMemberProfile(items: items)]
    }
}

extension SectionOfFamilyMemberProfile {
    static func generateTestData() -> [SectionOfFamilyMemberProfile] {
        var items: [SectionOfFamilyMemberProfile.Item] = []

        let memberId = ["KKW", "KDH", "MKM", "UKH"]
        let names = ["김건우", "김도현", "마경미", "유건희"]
        let imageUrls = [
            "https://cdn.pixabay.com/photo/2023/11/20/13/48/butterfly-8401173_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/11/10/02/30/woman-8378634_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/11/26/08/27/leaves-8413064_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/09/03/17/00/chives-8231068_1280.jpg"
        ]
        
        (0...3).forEach {
            let item = FamilyMemeberProfile(
                memberId: memberId[$0],
                name: names[$0],
                imageUrl: imageUrls[$0]
            )
            items.append(item)
        }
        
        return [SectionOfFamilyMemberProfile(items: items)]
    }
}
