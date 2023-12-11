//
//  FeedDetailData.swift
//  App
//
//  Created by 마경미 on 10.12.23.
//

import RxDataSources

struct EmojiData {
    let emoji: String
    let count: Int
}

struct SectionOfFeedDetail {
    var header: String
    var items: [SectionItem]
}

// 섹션 데이터의 아이템 유형 정의
enum SectionItem {
    case feed(feedData: FeedData)
    case emoji(emojiData: EmojiData)
}

// 섹션 데이터: SectionModelType
extension SectionOfFeedDetail: SectionModelType {
    typealias Item = SectionItem
    
    init(original: SectionOfFeedDetail, items: [Item]) {
        self = original
        self.items = items
    }
}

extension SectionOfFeedDetail {
    static var sections: [SectionOfFeedDetail] = {
        return [
            SectionOfFeedDetail(header: "Feed Section", items: [
                .feed(feedData: FeedData(name: "Jenny", time: "오후 1:28:59", imageURL: "https://cdn.travie.com/news/photo/first/201710/img_19975_1.jpg")),
                .feed(feedData: FeedData(name: "Jenny", time: "오후 1:28:59", imageURL: "https://cdn.travie.com/news/photo/first/201710/img_19975_1.jpg")),
                .feed(feedData: FeedData(name: "Jenny", time: "오후 1:28:59", imageURL: "https://cdn.travie.com/news/photo/first/201710/img_19975_1.jpg"))]),
            SectionOfFeedDetail(header: "Emoji Section", items: [.emoji(emojiData: EmojiData(emoji: "😀", count: 4)), .emoji(emojiData: EmojiData(emoji: "😎", count: 4))])
        ]
    }()
}
