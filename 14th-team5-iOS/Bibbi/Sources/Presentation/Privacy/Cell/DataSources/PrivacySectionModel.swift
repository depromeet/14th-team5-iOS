//
//  PrivacySectionModel.swift
//  App
//
//  Created by Kim dohyun on 12/16/23.
//

import Foundation

import RxDataSources


public enum PrivacySectionType: String, Equatable {
    case privacy
    case authorization
}


public enum PrivacySectionModel: SectionModelType {
    case privacyWithAuth([PrivacyItemModel])
    case userAuthorization([PrivacyItemModel])
    
    public var items: [PrivacyItemModel] {
        switch self {
        case let .privacyWithAuth(items): return items
        case let .userAuthorization(items): return items
        }
    }
    
    
    public init(original: PrivacySectionModel, items: [PrivacyItemModel]) {
        switch original {
        case .privacyWithAuth: self = .privacyWithAuth(items)
        case .userAuthorization: self = .userAuthorization(items)
        }
        
    }
    
}


public enum PrivacyItemModel {
    case privacyWithAuthItem(PrivacyCellReactor)
    case userAuthorizationItem(PrivacyCellReactor)
}


extension PrivacySectionModel {
    
    public func getSectionType() -> PrivacySectionType {
        switch self {
        case .privacyWithAuth: return .privacy
        case .userAuthorization: return .authorization
        }
    }
}
