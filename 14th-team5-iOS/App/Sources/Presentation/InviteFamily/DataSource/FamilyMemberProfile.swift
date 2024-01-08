//
//  FamiliyMemeberProfileModel.swift
//  App
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Domain
import RxDataSources

//: Deprecated
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
