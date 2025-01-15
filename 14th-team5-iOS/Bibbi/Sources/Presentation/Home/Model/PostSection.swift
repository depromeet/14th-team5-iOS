//
//  SectionOfFeed.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import Domain
import RxDataSources

public struct PostSection {
    public typealias Model = SectionModel<Int, Item>
    
    public enum Item {
        case main(PostEntity)
    }
}

extension PostSection.Item: Equatable, Hashable {
    public static func == (lhs: PostSection.Item, rhs: PostSection.Item) -> Bool {
        switch (lhs, rhs) {
        case (.main(let leftPost), .main(let rightPost)):
            return leftPost == rightPost
        default:
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .main(let post):
            hasher.combine(post)
        default:
            break
        }
    }
}
