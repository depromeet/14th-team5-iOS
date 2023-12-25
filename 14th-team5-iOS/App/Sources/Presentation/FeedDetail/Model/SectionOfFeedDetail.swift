//
//  FeedDetailData.swift
//  App
//
//  Created by 마경미 on 10.12.23.
//

import RxDataSources

struct FeedDetailData {
    let writer: String
    let time: String
    let imageURL: String
    let imageText: String
    let emojis: [EmojiData]
}

struct EmojiData {
    let emoji: Emojis
    var count: Int
}

struct SectionOfFeedDetail {
    var items: [FeedDetailData]
    
    init(items: [FeedDetailData]) {
        self.items = items
    }
}

extension SectionOfFeedDetail: SectionModelType {
    typealias Item = FeedDetailData
    
    init(original: SectionOfFeedDetail, items: [FeedDetailData]) {
        self = original
        self.items = items
    }
}

extension SectionOfFeedDetail {
    static var sections: [SectionModel<String, FeedDetailData>] {
        return [
            SectionModel<String, FeedDetailData>(model: "section1", items: [
                FeedDetailData(writer: "Jenny", time: "오후 3:28:59", imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg", imageText: "찰칵~", emojis: [
                ]),
                FeedDetailData(writer: "Jenny", time: "오후 3:28:59", imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg", imageText: "찰칵~", emojis: [
                ]),
                FeedDetailData(writer: "Jenny", time: "오후 3:28:59", imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg", imageText: "찰칵~", emojis: [
                ])
            ])
        ]
    }
}
