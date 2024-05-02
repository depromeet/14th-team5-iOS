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
import Core

public final class CameraDisplayViewReactor: Reactor {

    public var initialState: State
    private var cameraDisplayUseCase: CameraDisplayViewUseCaseProtocol
    
    public enum Action {
        case viewDidLoad
        case didTapArchiveButton
        case fetchDisplayImage(String)
        case didTapConfirmButton
        case hideDisplayEditCell
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setError(Bool)
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
        var cameraType: PostType
        @Pulse var isError: Bool
        @Pulse var displayData: Data
        @Pulse var missionTitle: String
        @Pulse var displaySection: [DisplayEditSectionModel]
        @Pulse var displayEntity: CameraDisplayImageResponse?
        @Pulse var displayOringalEntity: Bool
        @Pulse var displayPostEntity: CameraDisplayPostResponse?
    }
    
    
    
    init(
      cameraDisplayUseCase: CameraDisplayViewUseCaseProtocol,
      displayData: Data,
      missionTitle: String,
      cameraType: PostType = .survival
    ) {
        self.cameraDisplayUseCase = cameraDisplayUseCase
        self.initialState = State(
            isLoading: true,
            displayDescrption: "",
            cameraType: cameraType,
            isError: false,
            displayData: displayData,
            missionTitle: missionTitle,
            displaySection: [.displayKeyword([])],
            displayEntity: nil,
            displayOringalEntity: false,
            displayPostEntity: nil
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let fileName = "\(currentState.displayData.hashValue).jpg"
            let parameters: CameraDisplayImageParameters = CameraDisplayImageParameters(imageName: "\(fileName)")
            
            return .concat(
                .just(.setLoading(false)),
                .just(.setError(false)),
                .just(.setRenderImage(currentState.displayData)),
                cameraDisplayUseCase.executeDisplayImageURL(parameters: parameters)
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .asObservable()
                    .flatMap { owner, entity -> Observable<CameraDisplayViewReactor.Mutation> in
                        guard let originalURL = entity?.imageURL else {
                            return .concat(
                                .just(.setLoading(true)),
                                .just(.setError(true))
                            )
                        }
                        return owner.cameraDisplayUseCase.executeUploadToS3(toURL: originalURL, imageData: owner.currentState.displayData)
                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .asObservable()
                            .flatMap { isSuccess -> Observable<CameraDisplayViewReactor.Mutation> in
                                if isSuccess {
                                    return .concat(
                                        .just(.setDisplayEntity(entity)),
                                        .just(.setDisplayOriginalEntity(isSuccess)),
                                        .just(.setLoading(true)),
                                        .just(.setError(false))
                                    )
                                } else {
                                    return .concat(
                                        .just(.setLoading(true)),
                                        .just(.setError(true))
                                    )
                                }
                            }
                    }
            )
        case let .fetchDisplayImage(description):
            return .concat(
                cameraDisplayUseCase.executeDescrptionItems(with: description)
                    .asObservable()
                    .flatMap { items -> Observable<CameraDisplayViewReactor.Mutation> in
                        var sectionItem: [DisplayEditItemModel] = []
                        items.forEach {
                            sectionItem.append(.fetchDisplayItem(DisplayEditCellReactor(title: $0, radius: 8, font: .head1)))
                        }
                        
                        return Observable.concat(
                            .just(.setDisplayEditSection(sectionItem)),
                            .just(.setDescription(description))
                        )
                    }
            )
        case .didTapArchiveButton:
            return .concat(
                .just(.setLoading(false)),
                .just(.saveDeviceimage(currentState.displayData)),
                .just(.setLoading(true))
            )
            
        case .didTapConfirmButton:
            
            MPEvent.Camera.uploadPhoto.track(with: nil)

            guard let presingedURL = currentState.displayEntity?.imageURL else { return .just(.setError(true)) }
            let originURL = configureOriginalS3URL(url: presingedURL)
            let cameraQuery = CameraMissionFeedQuery(type: currentState.cameraType.rawValue, isUploded: true)
            
            let parameters: CameraDisplayPostParameters = CameraDisplayPostParameters(
                imageUrl: originURL,
                content: currentState.displayDescrption,
                uploadTime: DateFormatter.yyyyMMddTHHmmssXXX.string(from: Date())
            )
            
            return cameraDisplayUseCase.executeCombineWithTextImage(parameters: parameters, query: cameraQuery)
                .asObservable()
                .catchAndReturn(nil)
                .flatMap { entity -> Observable<CameraDisplayViewReactor.Mutation> in
                    if entity == nil  {
                        return .just(.setError(true))
                    } else {
                        return .concat(
                            .just(.setLoading(false)),
                            .just(.setPostEntity(entity)),
                            .just(.setLoading(true)),
                            .just(.setError(false))
                        )
                    }
                }
        case .hideDisplayEditCell:
            return .concat(
                .just(.setDescription("")),
                .just(.setDisplayEditSection([]))
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
        case let .setDisplayEntity(entity):
            newState.displayEntity = entity
        case let .setDisplayOriginalEntity(entity):
            newState.displayOringalEntity = entity
        case let .setPostEntity(entity):
            newState.displayPostEntity = entity
        case let .setError(isError):
            newState.isError = isError
        }
        return newState
    }
    
    
}

extension CameraDisplayViewReactor {
    
    func getSection(_ section: DisplayEditSectionModel) -> Int {
        var index: Int = 0
        
        for i in 0 ..< currentState.displaySection.count where currentState.displaySection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
    
    
    func configureOriginalS3URL(url: String) -> String {
        guard let range = url.range(of: #"[^&?]+"#, options: .regularExpression) else { return "" }
        return String(url[range])
    }
}

