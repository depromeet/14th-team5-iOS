//
//  SectionOfFamily.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import RxDataSources

public struct ProfileData {
    let imageURL: String
    let name: String
}

// 섹션데이터
struct SectionOfFamily {
    var items: [ProfileData]
    
    init(items: [ProfileData]) {
        self.items = items
    }
}

// 섹션 데이터: SectionModelType
extension SectionOfFamily: SectionModelType {
    typealias Item = ProfileData
    
    init(original: SectionOfFamily, items: [ProfileData]) {
        self = original
        self.items = items
    }
}

extension SectionOfFamily {
    static var sections: [SectionModel<String, ProfileData>] {
        return [
            SectionModel<String, ProfileData>(model: "section1", items: [
            ProfileData(imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg", name: "Jenny"),
            ProfileData(imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg", name: "Jenny"),
            ProfileData(imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg", name: "Jenny"),
            ProfileData(imageURL: "https://wimg.mk.co.kr/news/cms/202304/14/news-p.v1.20230414.15e6ac6d76a84ab398281046dc858116_P1.jpg", name: "Jenny"),
            ])
        ]
    }
}
