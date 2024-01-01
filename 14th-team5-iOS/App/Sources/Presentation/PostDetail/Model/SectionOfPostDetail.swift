//
//  FeedDetailData.swift
//  App
//
//  Created by 마경미 on 10.12.23.
//

import Domain

import RxDataSources

struct SectionOfPostDetail {
    var items: [PostData]
    
    init(items: [PostData]) {
        self.items = items
    }
}

extension SectionOfPostDetail: SectionModelType {
    typealias Item = PostData
    
    init(original: SectionOfPostDetail, items: [PostData]) {
        self = original
        self.items = items
    }
}
