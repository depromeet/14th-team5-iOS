//
//  FeedDetailData.swift
//  App
//
//  Created by 마경미 on 10.12.23.
//

import Domain

import RxDataSources

struct SectionOfFeedDetail {
    var items: [PostData]
    
    init(items: [PostData]) {
        self.items = items
    }
}

extension SectionOfFeedDetail: SectionModelType {
    typealias Item = PostData
    
    init(original: SectionOfFeedDetail, items: [PostData]) {
        self = original
        self.items = items
    }
}

//extension SectionOfFeedDetail {
//    static var sections: [SectionModel<String, FeedDetailData>] {
//        return [
//            SectionModel<String, FeedDetailData>(model: "section1", items: [
//                FeedDetailData(writer: "Jenny", time: "오후 3:28:59", imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg", imageText: "찰칵~", emojis: [
//                ]),
//                FeedDetailData(writer: "Jenny", time: "오후 3:28:59", imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg", imageText: "찰칵~", emojis: [
//                ]),
//                FeedDetailData(writer: "Jenny", time: "오후 3:28:59", imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg", imageText: "찰칵~", emojis: [
//                ])
//            ])
//        ]
//    }
//}
