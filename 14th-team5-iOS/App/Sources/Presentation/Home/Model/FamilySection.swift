//
//  SectionOfFamily.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import RxDataSources
import Domain

//struct FamilySection {
//    typealias Model = SectionModel<Int, Item>
//    
//    enum Item {
//        case main(ProfileData)
//    }
//}
//
//extension FamilySection.Item: Equatable, Hashable {
//    public static func == (lhs: FamilySection.Item, rhs: FamilySection.Item) -> Bool {
//        switch (lhs, rhs) {
//        case (.main(let leftFamily), .main(let rightFamily)):
//            return leftFamily == rightFamily
//        default:
//            return false
//        }
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        switch self {
//        case .main(let family):
//            hasher.combine(family)
//        default:
//            break
//        }
//    }
//}
