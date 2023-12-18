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
}


extension ProfileFeedSectionModel {
    public func getSectionType() -> ProfileFeedSectionType {
        switch self {
        case .feedCategory: return .feed
        }
    }
}
