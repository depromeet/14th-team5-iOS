//
//  CameraDisplayViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import Foundation

import Data
import Domain
import ReactorKit



public final class CameraDisplayViewReactor: Reactor {

    public var initialState: State
    private var cameraDisplayUseCase: CameraDisplayViewUseCaseProtocol
    
    public enum Action {
        case viewDidLoad
        case didTapArchiveButton
        case fetchDisplayImage(String)
        case didTapConfirmButton
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setDisplayEditSection([DisplayEditItemModel])
        case setRenderImage(Data)
        case saveDeviceimage(Data)
        case setDescription(String)
        case setDisplayEntity(CameraDisplayImageResponse?)
        case setDisplayOriginalEntity(Bool)
        case setPostEntity(CameraDisplayPostResponse?)
    }
    
    public struct State {
        var isLoading: Bool
        var displayDescrption: String
        @Pulse var displayData: Data
        @Pulse var displaySection: [DisplayEditSectionModel]
        @Pulse var displayEntity: CameraDisplayImageResponse?
        @Pulse var displayOringalEntity: Bool
        @Pulse var displayPostEntity: CameraDisplayPostResponse?
    }
    
    
    
    init(cameraDisplayUseCase: CameraDisplayViewUseCaseProtocol, displayData: Data) {
        self.cameraDisplayUseCase = cameraDisplayUseCase
        self.initialState = State(
            isLoading: false,
            displayDescrption: "",
            displayData: displayData,
            displaySection: [.displayKeyword([])],
            displayEntity: nil,
            displayOringalEntity: false,
            displayPostEntity: nil
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let fileName = "\(self.currentState.displayData.hashValue).jpg"
            let parameters: CameraDisplayImageParameters = CameraDisplayImageParameters(imageName: "\(fileName).jpg")
            
            return .concat(
                .just(.setLoading(true)),
                .just(.setRenderImage(self.currentState.displayData)),
                cameraDisplayUseCase.executeDisplayImageURL(parameters: parameters, type: .feed)
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .asObservable()
                    .flatMap { owner, entity -> Observable<CameraDisplayViewReactor.Mutation> in
                        owner.cameraDisplayUseCase.executeUploadToS3(toURL: entity?.imageURL ?? "", imageData: owner.currentState.displayData)
                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .asObservable()
                            .flatMap { isSuccess -> Observable<CameraDisplayViewReactor.Mutation> in
                                return .concat(
                                    .just(.setDisplayEntity(entity)),
                                    .just(.setDisplayOriginalEntity(isSuccess)),
                                    .just(.setLoading(false))
                                )
                                
                            }
                        
                    }
            )
        case let .fetchDisplayImage(description):
            return .concat(
                .just(.setLoading(true)),
                cameraDisplayUseCase.executeDescrptionItems(with: description)
                    .asObservable()
                    .flatMap { items -> Observable<CameraDisplayViewReactor.Mutation> in
                        var sectionItem: [DisplayEditItemModel] = []
                        items.forEach {
                            sectionItem.append(.fetchDisplayItem(DisplayEditCellReactor(title: $0, radius: 8, font: .head1)))
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
            
        case .didTapConfirmButton:
            guard let presingedURL = self.currentState.displayEntity?.imageURL else { return .empty() }
            let originURL = configureOriginalS3URL(url: presingedURL, with: .feed)
            
            let parameters: CameraDisplayPostParameters = CameraDisplayPostParameters(
                imageUrl: originURL,
                content: self.currentState.displayDescrption,
                uploadTime: DateFormatter.yyyyMMddTHHmmssXXX.string(from: Date())
            )
            
            return cameraDisplayUseCase.executeCombineWithTextImage(parameters: parameters)
                .asObservable()
                .flatMap { entity -> Observable<CameraDisplayViewReactor.Mutation> in
                    return .concat(
                        .just(.setLoading(true)),
                        .just(.setPostEntity(entity)),
                        .just(.setLoading(false))
                    )
                    
                }
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
        case let .setDisplayEntity(entity):
            newState.displayEntity = entity
        case let .setDisplayOriginalEntity(entity):
            newState.displayOringalEntity = entity
        case let .setPostEntity(entity):
            newState.displayPostEntity = entity
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
    
    
    func configureOriginalS3URL(url: String, with filePath: UploadLocation) -> String {
        guard let range = url.range(of: #"[^&?]+"#, options: .regularExpression) else { return "" }
        return String(url[range])
    }
}

