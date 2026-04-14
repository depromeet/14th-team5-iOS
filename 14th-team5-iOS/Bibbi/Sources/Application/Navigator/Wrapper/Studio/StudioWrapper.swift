//
//  Studio.swift
//  Bibbi
//
//  Created by 마경미 on 25.09.25.
//

import Core
import Domain
import Foundation
import MacrosInterface

@Wrapper<StudioReactor, StudioViewController>
final class StudioViewControllerWrapper {

    private let theme: StudioThemeEntity

    init(theme: StudioThemeEntity) {
        self.theme = theme
    }

    func makeReactor() -> R {
        return StudioReactor(theme: theme)
    }
}
