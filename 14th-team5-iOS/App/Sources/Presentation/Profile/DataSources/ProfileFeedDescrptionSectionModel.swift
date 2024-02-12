//
//  ProfileFeedDescrptionSectionModel.swift
//  App
//
//  Created by Kim dohyun on 2/10/24.
//

import Foundation


import RxDataSources

public enum ProfileFeedDescrptionSectionType: String, Equatable {
    case feedDescrption
}

public enum ProfileFeedDescrptionSectionModel: SectionModelType {
    case feedDescrption([ProfileFeedDescrptionSectionItem])
    
    public var items: [ProfileFeedDescrptionSectionItem] {
        switch self {
        case let .feedDescrption(items): return items
        }
    }
    
    public init(original: ProfileFeedDescrptionSectionModel, items: [ProfileFeedDescrptionSectionItem]) {
        switch original {
        case .feedDescrption: self = .feedDescrption(items)
            
        }
    }
    
}


public enum ProfileFeedDescrptionSectionItem {
    case feedDescrptionItem(ProfileFeedDescrptionCellReactor)
}


extension ProfileFeedDescrptionSectionModel {
    public func getSectionType() -> ProfileFeedDescrptionSectionType {
        switch self {
        case .feedDescrption: return .feedDescrption
        }
    }
}
