//
//  SectionOfFamily.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import RxDataSources
import Domain

struct SectionOfFamily {
    var items: [ProfileData]
    
    init(items: [ProfileData]) {
        self.items = items
    }
}

extension SectionOfFamily: SectionModelType {
    typealias Item = ProfileData
    
    init(original: SectionOfFamily, items: [ProfileData]) {
        self = original
        self.items = items
    }
}
