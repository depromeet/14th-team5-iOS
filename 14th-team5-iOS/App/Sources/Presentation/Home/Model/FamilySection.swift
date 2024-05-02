//
//  SectionOfFamily.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import RxDataSources
import Domain

struct FamilySection {
    typealias Model = SectionModel<Int, Item>
    
    enum Item {
        case main(MainFamilyCellReactor)
    }
}

extension FamilySection.Item: Equatable { }
