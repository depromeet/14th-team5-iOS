//
//  SectionOfFeed.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import Domain
import RxDataSources

struct SectionOfFeed {
    var items: [PostListData]
    
    init(items: [PostListData]) {
        self.items = items
    }
}

extension SectionOfFeed: SectionModelType {
    typealias Item = PostListData
    
    init(original: SectionOfFeed, items: [PostListData]) {
        self = original
        self.items = items
    }
}
