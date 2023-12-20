//
//  FamiliyMemeberProfileModel.swift
//  App
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import RxDataSources

public struct YourFamiliyMemeberProfile {
    var memberId: String
    var name: String
    var imageUrl: String?
}

public struct SectionOfYourFamiliyMemberProfile {
    public var items: [Item]
}

extension SectionOfYourFamiliyMemberProfile: SectionModelType {
    public typealias Item = YourFamiliyMemeberProfile
    
    public init(original: SectionOfYourFamiliyMemberProfile, items: [YourFamiliyMemeberProfile]) {
        self = original
        self.items = items
    }
}
