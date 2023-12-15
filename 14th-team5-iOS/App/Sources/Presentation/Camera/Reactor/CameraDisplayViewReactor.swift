//
//  CameraDisplayViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import Foundation

import Data
import ReactorKit



public final class CameraDisplayViewReactor: Reactor {

    public var initialState: State
    private var cameraDisplayRepository: CameraDisplayImpl
    
    public enum Action {
        case viewDidLoad
        case didTapArchiveButton
        case fetchDisplayImage(String)
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setDisplayEditSection([DisplayEditItemModel])
        case setRenderImage(Data)
        case saveDeviceimage(Data)
        case setDescription(String)
    }
    
    public struct State {
        var isLoading: Bool
        var displayDescrption: String
        @Pulse var displayData: Data
        @Pulse var displaySection: [DisplayEditSectionModel]
    }
    
    
    
    init(cameraDisplayRepository: CameraDisplayImpl, displayData: Data) {
        self.cameraDisplayRepository = cameraDisplayRepository
        self.initialState = State(
            isLoading: false,
            displayDescrption: "",
            displayData: displayData,
            displaySection: [.displayKeyword([])]
        )
        
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.setLoading(true)),
                .just(.setRenderImage(self.currentState.displayData)),
                .just(.setLoading(false))
            )
        case let .fetchDisplayImage(description):
            return .concat(
                .just(.setLoading(true)),
                cameraDisplayRepository.generateDescrption(with: description)
                    .asObservable()
                    .flatMap { items -> Observable<CameraDisplayViewReactor.Mutation> in
                        var sectionItem: [DisplayEditItemModel] = []
                        items.forEach {
                            sectionItem.append(.fetchDisplayItem(DisplayEditCellReactor(title: $0)))
                        }
                        
                        return Observable.concat(
                            .just(.setDisplayEditSection(sectionItem)),
                            .just(.setDescription(description)),
                            .just(.setLoading(false))
                        )
                    }
            )
        case .didTapArchiveButton:
            return .concat(
                .just(.setLoading(true)),
                .just(.saveDeviceimage(self.currentState.displayData)),
                .just(.setLoading(false))
            )
        }
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setRenderImage(originalData):
            newState.displayData = originalData
        case let .saveDeviceimage(saveData):
            newState.displayData = saveData
        case let .setDisplayEditSection(section):
            let sectionIndex = getSection(.displayKeyword([]))
            newState.displaySection[sectionIndex] = .displayKeyword(section)
        case let .setDescription(descrption):
            newState.displayDescrption = descrption
        }
        return newState
    }
    
    
}

extension CameraDisplayViewReactor {
    
    func getSection(_ section: DisplayEditSectionModel) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.displaySection.count where self.currentState.displaySection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
    
}
