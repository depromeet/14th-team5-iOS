//
//  ProfileFeedSectionModel.swift
//  App
//
//  Created by Kim dohyun on 12/18/23.
//

import Foundation

import RxDataSources

public enum ProfileFeedSectionType: String, Equatable {
    case feed
    case empty
}

public enum ProfileFeedSectionModel: SectionModelType {
    case feedCategory([ProfileFeedSectionItem])
    
    public var items: [ProfileFeedSectionItem] {
        switch self {
        case let .feedCategory(items): return items
        }
    }
    
    public init(original: ProfileFeedSectionModel, items: [ProfileFeedSectionItem]) {
        switch original {
        case .feedCategory: self = .feedCategory(items)
        }
    }
    
    
}


public enum ProfileFeedSectionItem {
    case feedCategoryItem(ProfileFeedCellReactor)
    case feedCateogryEmptyItem(ProfileFeedEmptyCellReactor)
}


extension ProfileFeedSectionModel {
    public func getSectionType() -> ProfileFeedSectionType {
        switch self {
        case let .feedCategory(items):
            if items.isEmpty {
                return .empty
            }
            return .feed
        }
    }
}
