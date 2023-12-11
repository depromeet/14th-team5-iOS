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
    
    func getEmojis() -> [EmojiData] {
        return emojis
    }
}

struct EmojiData {
    let emoji: String
    let count: Int
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
                    EmojiData(emoji: "😆", count: 4),
                    EmojiData(emoji: "😆", count: 4),
                    EmojiData(emoji: "😆", count: 4),
                    EmojiData(emoji: "😆", count: 4),
                ]),
                FeedDetailData(writer: "Jenny", time: "오후 3:28:59", imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg", imageText: "찰칵~", emojis: [
                    EmojiData(emoji: "😆", count: 4),
                    EmojiData(emoji: "😆", count: 4),
                    EmojiData(emoji: "😆", count: 4),
                    EmojiData(emoji: "😆", count: 4),
                ]),
                FeedDetailData(writer: "Jenny", time: "오후 3:28:59", imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg", imageText: "찰칵~", emojis: [
                    EmojiData(emoji: "😆", count: 4),
                    EmojiData(emoji: "😆", count: 4),
                    EmojiData(emoji: "😆", count: 4),
                    EmojiData(emoji: "😆", count: 4),
                ])
            ])
        ]
    }
}

//// 섹션 데이터의 아이템 유형 정의
//enum SectionItem {
//    case feed(feedData: FeedData)
//    case emoji(emojiData: EmojiData)
//}
//
//// 섹션 데이터: SectionModelType
//extension SectionOfFeedDetail: SectionModelType {
//    typealias Item = SectionItem
//    
//    init(original: SectionOfFeedDetail, items: [Item]) {
//        self = original
//        self.items = items
//    }
//}
//
//extension SectionOfFeedDetail {
//    static var sections: [SectionOfFeedDetail] = {
//        return [
//            SectionOfFeedDetail(header: "Feed Section", items: [
//                .feed(feedData: FeedData(name: "Jenny", time: "오후 1:28:59", imageURL: "https://cdn.travie.com/news/photo/first/201710/img_19975_1.jpg")),
//                .feed(feedData: FeedData(name: "Jenny", time: "오후 1:28:59", imageURL: "https://cdn.travie.com/news/photo/first/201710/img_19975_1.jpg")),
//                .feed(feedData: FeedData(name: "Jenny", time: "오후 1:28:59", imageURL: "https://cdn.travie.com/news/photo/first/201710/img_19975_1.jpg"))]),
//            SectionOfFeedDetail(header: "Emoji Section", items: [.emoji(emojiData: EmojiData(emoji: "😀", count: 4)), .emoji(emojiData: EmojiData(emoji: "😎", count: 4))])
//        ]
//    }()
//}
