//
//  FamilyWidgetDIContainer.swift
//  WidgetExtension
//
//  Created by 마경미 on 05.06.24.
//

import Foundation

import Core
import Data
import Domain

final class FamilyWidgetDIContainer {
    
    func makeRepository() -> WidgetRepositoryProtocol {
        return WidgetRepository()
    }
    
    func makeUseCase() -> FetchRecentFamilyPostUseCaseProtocol {
        return FetchRecentFamilyPostUseCase(widgetRepository: makeRepository())
    }
    
    func makeProvider() -> FamilyWidgetTimelineProvider {
        return .init(repository: makeRepository())
    }
}
