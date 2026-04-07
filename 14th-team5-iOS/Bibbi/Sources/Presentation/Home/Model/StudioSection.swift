//
//  StudioSection.swift
//  Bibbi
//
//  Created by 마경미 on 19.02.26.
//

import RxDataSources
import Domain

struct StudioSection: SectionModelType {
    var items: [StudioThemeEntity]

    init(original: StudioSection, items: [StudioThemeEntity]) {
        self = original
        self.items = items
    }
    
    init(items: [StudioThemeEntity]) {
        self.items = items
    }

    typealias Item = StudioThemeEntity
}
