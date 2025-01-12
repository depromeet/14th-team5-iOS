//
//  DisplayEditSectionModel.swift
//  App
//
//  Created by Kim dohyun on 12/13/23.
//

import Foundation

import RxDataSources


enum DisplayEditType: String, Equatable {
    case displayEdit
}

public enum DisplayEditSectionModel: SectionModelType {
    case displayKeyword([DisplayEditItemModel])
    
    public var items: [DisplayEditItemModel] {
        switch self {
        case let .displayKeyword(items): return items
        }
    }
    
    public init(original: DisplayEditSectionModel, items: [DisplayEditItemModel]) {
        switch original {
        case .displayKeyword: self = .displayKeyword(items)
        }
    }
}



public enum DisplayEditItemModel {
    case fetchDisplayItem(DisplayEditCellReactor)
}

extension DisplayEditSectionModel {
    func getSectionType() -> DisplayEditType {
        switch self {
        case .displayKeyword: return .displayEdit
        }
    }
}
