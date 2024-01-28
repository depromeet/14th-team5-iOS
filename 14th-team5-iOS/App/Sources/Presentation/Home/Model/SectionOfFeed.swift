//
//  SectionOfFeed.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import Domain
import RxDataSources

public struct SectionOfFeed {
    public var items: [PostListData]
    
    init(items: [PostListData]) {
        self.items = items
    }
}

extension SectionOfFeed: SectionModelType {
    public typealias Item = PostListData
    
    public init(original: SectionOfFeed, items: [PostListData]) {
        self = original
        self.items = items
    }
}

public struct PostSection {
  public typealias Model = SectionModel<Int, Item>
  
  public enum Item {
    case main(PostListData)
  }
}

extension PostSection.Item: Equatable {
  
}
