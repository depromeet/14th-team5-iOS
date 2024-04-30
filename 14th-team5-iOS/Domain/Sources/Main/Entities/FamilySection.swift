//
//  FamilySection.swift
//  Domain
//
//  Created by 마경미 on 29.04.24.
//

import Foundation
import RxDataSources

public struct FamilySection {
    public typealias Model = SectionModel<Int, Item>
    
    public enum Item {
        case main(ProfileData)
    }
}

extension FamilySection.Item: Equatable, Hashable {
    public static func == (lhs: FamilySection.Item, rhs: FamilySection.Item) -> Bool {
        switch (lhs, rhs) {
        case (.main(let leftFamily), .main(let rightFamily)):
            return leftFamily == rightFamily
        default:
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .main(let family):
            hasher.combine(family)
        default:
            break
        }
    }
}
