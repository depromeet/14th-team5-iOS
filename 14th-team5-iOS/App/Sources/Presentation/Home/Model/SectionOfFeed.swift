//
//  SectionOfFeed.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import RxDataSources

public struct FeedData {
    let name: String
    let time: String
    let imageURL: String
}

struct SectionOfFeed {
    var items: [FeedData]
    
    init(items: [FeedData]) {
        self.items = items
    }
}

extension SectionOfFeed: SectionModelType {
    typealias Item = FeedData
    
    init(original: SectionOfFeed, items: [FeedData]) {
        self = original
        self.items = items
    }
}

extension SectionOfFeed {
    static var sections: [SectionModel<String, FeedData>] {
        return [
            SectionModel<String, FeedData>(model: "section1", items: [
                FeedData(name: "Jeenny", time: "오후 1:28:59", imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg"),
                FeedData(name: "Jeenny", time: "오후 1:28:59", imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg"),
                FeedData(name: "Jeenny", time: "오후 1:28:59", imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg"),
                FeedData(name: "Jeenny", time: "오후 1:28:59", imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg"),
            ])
        ]
    }
}
