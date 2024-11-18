//
//  CameraDisplayViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import Foundation

import Data
import Domain
import DesignSystem
import ReactorKit
import Core

public final class CameraDisplayViewReactor: Reactor {
    
    public var initialState: State
    @Injected private var provider: ServiceProviderProtocol
    @Injected private var createPresignedCameraUseCase: CreateCameraUseCaseProtocol
    @Injected private var uploadImageUseCase: FetchCameraUploadImageUseCaseProtocol
    @Injected private var fetchCameraImageUseCase: CreateCameraImageUseCaseProtocol
    @Navigator private var cameraDisplayNavigator: CameraDisplayNavigatorProtocol
    
    public enum Action {
        case viewDidLoad
        case didTapArchiveButton
        case fetchDisplayImage(String)
        case didTapConfirmButton
        case hideDisplayEditCell
        case showInputTextError
        case showInputBlankTextError(String)
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setError(Bool)
        case setDisplayEditSection([DisplayEditItemModel])
        case setRenderImage(Data)
        case saveDeviceimage(Data)
        case setDescription(String)
        case setTrimedText(String)
        case setDisplayEntity(CameraPreSignedEntity?)
        case setDisplayOriginalEntity(Bool)
        case setPostEntity(CameraPostEntity?)
    }
    
    public struct State {
        var isLoading: Bool
        var displayDescrption: String
        var cameraType: PostType
        @Pulse var isError: Bool
        @Pulse var displayData: Data
        @Pulse var missionTitle: String
        @Pulse var displaySection: [DisplayEditSectionModel]
        @Pulse var displayEntity: CameraPreSignedEntity?
        @Pulse var displayOringalEntity: Bool
        @Pulse var displayPostEntity: CameraPostEntity?
        @Pulse var displayText: String
    }
    
    
    
    init(
        displayData: Data,
        missionTitle: String,
        cameraType: PostType = .survival
    ) {
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
            displayPostEntity: nil,
            displayText: ""
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let fileName = "\(currentState.displayData.hashValue).jpg"
            let body = CreatePresignedURLRequest(imageName: fileName)
            return .concat(
                .just(.setLoading(false)),
                .just(.setError(false)),
                .just(.setRenderImage(currentState.displayData)),
                createPresignedCameraUseCase.execute(body: body)
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .flatMap { owner, entity -> Observable<CameraDisplayViewReactor.Mutation> in
                        guard let remoteURL = entity?.imageURL else {
                            return .concat(
                                .just(.setLoading(true)),
                                .just(.setError(true))
                            )
                        }
                        return owner.uploadImageUseCase.execute(remoteURL, image: owner.currentState.displayData)
                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
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
                Observable.of(Array(description))
                    .map { String($0) }
                    .flatMap { items -> Observable<CameraDisplayViewReactor.Mutation> in
                        var sectionItem: [DisplayEditItemModel] = []
                        
                        items.forEach {
                            sectionItem.append(.fetchDisplayItem(DisplayEditCellReactor(title: String($0), radius: 8, font: .head1)))
                        }
                        
                        return .concat(
                            .just(.setDisplayEditSection(sectionItem)),
                            .just(.setDescription(description))
                        )
                    }
            )
        case .didTapArchiveButton:
            let config = BBToastConfiguration(direction: .bottom(yOffset: -20), animationTime: 1.0)
            let viewConfig = BBToastViewConfiguration(minWidth: 207)
            provider.bbToastService.show(
                image:DesignSystemAsset.camera.image.withTintColor(DesignSystemAsset.gray300.color),
                title: "사진이 저장되었습니다.",
                viewConfig: viewConfig,
                config: config
                )
            return .concat(
                .just(.setLoading(false)),
                .just(.saveDeviceimage(currentState.displayData)),
                .just(.setLoading(true))
            )
            
        case .didTapConfirmButton:
            
            MPEvent.Camera.uploadPhoto.track(with: nil)
            
            guard let presingedURL = currentState.displayEntity?.imageURL else { return .just(.setError(true)) }
            let remoteURL = configureOriginalS3URL(url: presingedURL)
            
            let query = CreateFeedQuery(type: currentState.cameraType.rawValue)
            let body = CreateFeedRequest(imageUrl: remoteURL, content: currentState.displayDescrption, uploadTime: DateFormatter.yyyyMMddTHHmmssXXX.string(from: .now))
        
            return fetchCameraImageUseCase.execute(query: query, body: body)
                .catchAndReturn(nil)
                .withUnretained(self)
                .flatMap { owner, entity -> Observable<CameraDisplayViewReactor.Mutation> in
                    if entity == nil  {
                        return .just(.setError(true))
                    } else {
                        owner.cameraDisplayNavigator.toHome()
                        return .concat(
                            .just(.setLoading(false)),
                            .just(.setPostEntity(entity)),
                            .just(.setLoading(true)),
                            .just(.setError(false)),
                            owner.provider.mainService.refreshMain()
                                .flatMap { _ in Observable<Mutation>.empty() }
                        )
                    }
                }
        case .hideDisplayEditCell:
            return .concat(
                .just(.setDescription("")),
                .just(.setDisplayEditSection([]))
            )
        case .showInputTextError:
            let config = BBToastConfiguration(direction: .bottom(yOffset: -360), animationTime: 1.0)
            let viewConfig = BBToastViewConfiguration(minWidth: 207)
            provider.bbToastService.show(
                image: DesignSystemAsset.warning.image,
                title: "8자까지 입력 가능해요",
                viewConfig: viewConfig,
                config: config
            )
            return .empty()
            
        case let .showInputBlankTextError(displayText):
            let config = BBToastConfiguration(direction: .bottom(yOffset: -360), animationTime: 1.0)
            let viewConfig = BBToastViewConfiguration(minWidth: 207)
            provider.bbToastService.show(
                image: DesignSystemAsset.warning.image,
                title: "띄어쓰기는 할 수 없어요",
                viewConfig: viewConfig,
                config: config
            )
            let generateText = displayText.trimmingCharacters(in: .whitespaces)
            return .just(.setTrimedText(generateText))
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
        case let .setTrimedText(displayText):
            newState.displayText = displayText
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

