//
//  CameraViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

import Domain
import Core
import ReactorKit




public final class CameraViewReactor: Reactor {
    
    public var initialState: State
    private var cameraUseCase: CameraViewUseCaseProtocol
    private let provider: GlobalStateProviderProtocol
    public var cameraType: UploadLocation
    public var memberId: String
    
    public enum Action {
        case viewDidLoad
        case didTapFlashButton
        case didTapToggleButton
        case didTapShutterButton(Data)
        case didTapRealEmojiPad(IndexPath)
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setPosition(Bool)
        case setFlashMode(Bool)
        case uploadImageToS3(Bool)
        case setAccountProfileData(Data)
        case setProfileImageURLResponse(CameraDisplayImageResponse?)
        case setProfileMemberResponse(ProfileMemberResponse?)
        case setRealEmojiImageURLResponse(CameraRealEmojiPreSignedResponse?)
        case setRealEmojiImageCreateResponse(CameraCreateRealEmojiResponse?)
        case setRealEmojiItems(CameraRealEmojiImageItemResponse?)
        case setRealEmojiSection([EmojiSectionItem])
        case setErrorAlert(Bool)
        case setRealEmojiType(String)
        case setSelectedIndexPath(Int)
        case setRealEmojiPadItem(String)
        case setUpdateEmojiImage(URL)
    }
    
    public struct State {
        var isLoading: Bool
        @Pulse var isFlashMode: Bool
        @Pulse var isSwitchPosition: Bool
        @Pulse var profileImageURLEntity: CameraDisplayImageResponse?
        @Pulse var realEmojiURLEntity: CameraRealEmojiPreSignedResponse?
        @Pulse var realEmojiCreateEntity: CameraCreateRealEmojiResponse?
        @Pulse var realEmojiEntity: CameraRealEmojiImageItemResponse?
        @Pulse var realEmojiSection: [EmojiSectionModel]
        var updateEmojiImage: URL?
        var emojiType: String
        var selectedEmojiPadItem: String
        var selectedIndexPath: Int
        var cameraType: UploadLocation = .feed
        var accountImage: Data?
        var memberId: String
        var isUpload: Bool
        var isError: Bool
        @Pulse var profileMemberEntity: ProfileMemberResponse?
    }
    
    init(cameraUseCase: CameraViewUseCaseProtocol,
         provider: GlobalStateProviderProtocol,
         cameraType: UploadLocation,
         memberId: String
    ) {
        self.cameraType = cameraType
        self.cameraUseCase = cameraUseCase
        self.memberId = memberId
        self.provider = provider
        self.initialState = State(
            isLoading: false,
            isFlashMode: false,
            isSwitchPosition: false,
            profileImageURLEntity: nil,
            realEmojiURLEntity: nil,
            realEmojiCreateEntity: nil,
            realEmojiEntity: nil,
            realEmojiSection: [.realEmoji([])],
            updateEmojiImage: nil,
            emojiType: "EMOJI_1",
            selectedEmojiPadItem: "",
            selectedIndexPath: 0,
            cameraType: cameraType,
            accountImage: nil,
            memberId: memberId,
            isUpload: false,
            isError: false,
            profileMemberEntity: nil
        )
        print("currentState Camera Type: \(self.currentState.cameraType) or memberID: \(self.currentState.memberId)")
    }
    
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            if cameraType == .realEmoji {
                return .concat(
                    .just(.setLoading(true)),
                    cameraUseCase.executeRealEmojiItems(memberId: memberId)
                        .withUnretained(self)
                        .flatMap { owner, entity -> Observable<CameraViewReactor.Mutation> in
                            var sectionItem: [EmojiSectionItem] = []
                            guard let realEmojiEntity = entity?.realEmojiItems else { return .just(.setErrorAlert(true))}
                            if realEmojiEntity.isEmpty {
                                CameraRealEmojiItems.allCases.enumerated().forEach {
                                    let isSelected: Bool = $0.offset == 0 ? true : false
                                    sectionItem.append(.realEmojiItem(BibbiRealEmojiCellReactor(provider: owner.provider, realEmojiImage: nil, defaultImage: $0.element.rawValue, isSelected: isSelected, indexPath: $0.offset, realEmojiId: "", realEmojiType: "")))
                                }
                            } else {
                                CameraRealEmojiItems.allCases.enumerated().forEach {
                                    let isSelected: Bool = $0.offset == 0 ? true : false
                                    if realEmojiEntity[safe: $0.offset] == nil {
                                        sectionItem.append(.realEmojiItem(BibbiRealEmojiCellReactor(provider: owner.provider, realEmojiImage: nil, defaultImage: $0.element.rawValue, isSelected: false, indexPath: $0.offset, realEmojiId: "", realEmojiType: "")))
                                    } else {
                                        sectionItem.append(.realEmojiItem(BibbiRealEmojiCellReactor(provider: owner.provider, realEmojiImage: realEmojiEntity[safe: $0.offset]?.realEmojiImageURL, defaultImage: "", isSelected: isSelected, indexPath: $0.offset, realEmojiId: realEmojiEntity[safe: $0.offset]?.realEmojiId ?? "", realEmojiType: "")))
                                    }
                                }                                
                            }
                            
                            return .concat(
                                .just(.setRealEmojiItems(entity)),
                                .just(.setRealEmojiSection(sectionItem)),
                                .just(.setErrorAlert(false)),
                                .just(.setLoading(false))
                            )
                        }
                )
            } else {
                return .empty()
            }
            
        case .didTapToggleButton:
            return cameraUseCase.executeToggleCameraPosition(self.currentState.isSwitchPosition).map { .setPosition($0) }
        case .didTapFlashButton:
            return cameraUseCase.executeToggleCameraFlash(self.currentState.isFlashMode).map { .setFlashMode($0) }
            
        case let .didTapShutterButton(fileData):
            return didTapShutterButtonMutation(imageData: fileData)
            
        case let .didTapRealEmojiPad(indexPath):
            provider.realEmojiGlobalState.didTapRealEmojiEvent(indexPath: indexPath.row)
            return .concat(
                .just(.setSelectedIndexPath(indexPath.row)),
                .just(.setRealEmojiPadItem(CameraRealEmojiItems.allCases[indexPath.row].rawValue)),
                .just(.setRealEmojiType(CameraRealEmojiItems.allCases[indexPath.row].emojiType))
            )
        }
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setPosition(isPosition):
            newState.isSwitchPosition = isPosition
        case let .setFlashMode(isFlash):
            newState.isFlashMode = isFlash
        case let .setProfileImageURLResponse(entity):
            newState.profileImageURLEntity = entity
        case let .uploadImageToS3(isProfileEdit):
            newState.isUpload = isProfileEdit
        case let .setProfileMemberResponse(entity):
            newState.profileMemberEntity = entity
        case let .setAccountProfileData(accountImage):
            newState.accountImage = accountImage
        case let .setRealEmojiImageURLResponse(entity):
            newState.realEmojiURLEntity = entity
            print("RealEmoji URL Entity: \(newState.realEmojiURLEntity)")
        case let .setRealEmojiImageCreateResponse(entity):
            newState.realEmojiCreateEntity = entity
            print("RealEmoji Create Entity: \(newState.realEmojiCreateEntity)")
        case let .setRealEmojiItems(items):
            print("set RealEmoji Items: \(items)")
            newState.realEmojiEntity = items
        case let .setRealEmojiSection(section):
            let sectionIndex = getSection(.realEmoji([]))
            newState.realEmojiSection[sectionIndex] = .realEmoji(section)
            print("RealEmoji Section Item \(newState.realEmojiSection)")
        case let .setErrorAlert(isError):
            newState.isError = isError
        case let .setRealEmojiPadItem(selectedEmojiItem):
            print("set RealEmoj pad Item : \(selectedEmojiItem)")
            newState.selectedEmojiPadItem = selectedEmojiItem
        case let .setSelectedIndexPath(indexPath):
            print("set selected Index Path: \(indexPath)")
            newState.selectedIndexPath = indexPath
        case let .setRealEmojiType(emojiType):
            print("set selected Emoji Type: \(emojiType)")
            newState.emojiType = emojiType
        case let .setUpdateEmojiImage(realEmoji):
            newState.updateEmojiImage = realEmoji
        }
        
        return newState
    }
    
}

extension CameraViewReactor {
    
    func getSection(_ section: EmojiSectionModel) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.realEmojiSection.count where self.currentState.realEmojiSection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
    
    func configureProfileOriginalS3URL(url: String, with filePath: UploadLocation) -> String {
        guard let range = url.range(of: #"[^&?]+"#, options: .regularExpression) else { return "" }
        return String(url[range])
    }
    
    
    private func didTapShutterButtonMutation(imageData: Data) -> Observable<CameraViewReactor.Mutation> {
      
        switch cameraType {
        case .feed, .profile:
            //Profile 관련 이미지 업로드 Mutation
            let profileImage = "\(imageData.hash).jpg"
            let profileParameter = CameraDisplayImageParameters(imageName: profileImage)
            
            return .concat(
                .just(.setLoading(true)),
                cameraUseCase.executeProfileImageURL(parameter: profileParameter, type: cameraType)
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .asObservable()
                    .flatMap { owner, entity -> Observable<CameraViewReactor.Mutation> in
                        guard let presingedURL = entity?.imageURL else { return .just(.setErrorAlert(true)) }
                        
                        return owner.cameraUseCase.executeUploadToS3(toURL: presingedURL, imageData: imageData)
                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .asObservable()
                            .flatMap { isSuccess -> Observable<CameraViewReactor.Mutation> in
                                
                                if owner.memberId.isEmpty {
                                    return .concat(
                                        .just(.setProfileImageURLResponse(entity)),
                                        .just(.setAccountProfileData(imageData)),
                                        .just(.setErrorAlert(false)),
                                        .just(.setLoading(false))
                                    )
                                }
                                
                                let originalURL = owner.configureProfileOriginalS3URL(url: presingedURL, with: .profile)
                                let profileImageEditParameter = ProfileImageEditParameter(profileImageUrl: originalURL)
                                
                                if isSuccess {
                                    return owner.cameraUseCase.executeEditProfileImage(memberId: owner.memberId, parameter: profileImageEditParameter)
                                        .asObservable()
                                        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                        .flatMap { editEntity -> Observable<CameraViewReactor.Mutation> in
                                            
                                            return .concat(
                                                .just(.setProfileImageURLResponse(entity)),
                                                .just(.uploadImageToS3(isSuccess)),
                                                .just(.setProfileMemberResponse(editEntity)),
                                                .just(.setErrorAlert(false)),
                                                .just(.setLoading(false))
                                            )
                                            
                                        }
                                } else {
                                    return .just(.setErrorAlert(true))
                                }
                                
                            }
                    }
                
            )
        case .realEmoji:
            let realEmojiImage = "\(imageData.hashValue).jpg"
            let realEmojiParameter = CameraRealEmojiParameters(imageName: realEmojiImage)
            guard let realEmojiEntity = currentState.realEmojiEntity?.realEmojiItems else { return .empty() }
            // realEmoji Item Count 와 indexPath 비교해서 indexpath가 크면 post로 생성, 아니면 put으로 수정하기 하는 방식과
            // realEmoji Item 에 safe: indexPath.row 에서 nil일경우 post로 아니면 Put으로 하는 방식이 있다.
            print("리얼 이모지 갯수 : \(realEmojiEntity.count) \(currentState.selectedIndexPath + 1)")
            if realEmojiEntity.count < currentState.selectedIndexPath + 1 {
                return .concat(
                    .just(.setLoading(true)),
                    cameraUseCase.executeRealEmojiImageURL(memberId: memberId, parameter: realEmojiParameter)
                        .withUnretained(self)
                        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                        .asObservable()
                        .flatMap { owner, entity -> Observable<CameraViewReactor.Mutation> in
                            guard let presingedURL = entity?.imageURL else { return .just(.setErrorAlert(true))}
                            
                            return owner.cameraUseCase.executeUploadToS3(toURL: presingedURL, imageData: imageData)
                                .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                .asObservable()
                                .flatMap { isSuccess -> Observable<CameraViewReactor.Mutation> in
                                    
                                    let originalURL = owner.configureProfileOriginalS3URL(url: presingedURL, with: .realEmoji)
                                    let realEmojiCreateParameter = CameraCreateRealEmojiParameters(type: owner.currentState.emojiType, imageUrl: originalURL)
                                    if isSuccess {
                                        return owner.cameraUseCase.executeRealEmojiUploadToS3(memberId: owner.memberId, parameter: realEmojiCreateParameter)
                                            .asObservable()
                                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                            .flatMap { realEmojiEntity -> Observable<CameraViewReactor.Mutation> in
                                                guard let createRealEmojiEntity = realEmojiEntity else { return .just(.setErrorAlert(true))}
                                                owner.provider.realEmojiGlobalState.createRealEmojiImage(indexPath: owner.currentState.selectedIndexPath, image: createRealEmojiEntity.realEmojiImageURL, emojiType: createRealEmojiEntity.realEmojiType)
                                                return owner.cameraUseCase.executeRealEmojiItems(memberId: owner.memberId)
                                                    .asObservable()
                                                    .flatMap { reloadEntity -> Observable<CameraViewReactor.Mutation> in
                                                        return .concat(
                                                            .just(.setRealEmojiImageURLResponse(entity)),
                                                            .just(.setRealEmojiItems(reloadEntity)),
                                                            .just(.uploadImageToS3(isSuccess)),
                                                            .just(.setRealEmojiImageCreateResponse(realEmojiEntity)),
                                                            .just(.setErrorAlert(false)),
                                                            .just(.setLoading(false))
                                                        )
                                                    }
                                                
                                            }
                                    } else {
                                        return .just(.setErrorAlert(true))
                                    }
                                    
                                }
                            
                        }
                
                )

            } else {
                let realEmojiImage = "\(imageData.hashValue).jpg"
                let realEmojiParameter = CameraRealEmojiParameters(imageName: realEmojiImage)
                return .concat(
                    .just(.setLoading(true)),
                    cameraUseCase.executeRealEmojiImageURL(memberId: memberId, parameter: realEmojiParameter)
                        .withUnretained(self)
                        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                        .asObservable()
                        .flatMap { owner, entity -> Observable<CameraViewReactor.Mutation> in
                            guard let presingedURL = entity?.imageURL else { return .just(.setErrorAlert(true))}
                            let originalURL = owner.configureProfileOriginalS3URL(url: presingedURL, with: .realEmoji)
                            let updateRealEmojiParameter = CameraUpdateRealEmojiParameters(imageUrl: originalURL)
                            return owner.cameraUseCase.executeUploadToS3(toURL: presingedURL, imageData: imageData)
                                .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                .asObservable()
                                .flatMap { isSuccess -> Observable<CameraViewReactor.Mutation> in
                                    if isSuccess {
                                        return owner.cameraUseCase.executeUpdateRealEmojiImage(memberId: owner.memberId, realEmojiId: realEmojiEntity[owner.currentState.selectedIndexPath].realEmojiId, parameter: updateRealEmojiParameter)
                                            .asObservable()
                                            .flatMap { updateRealEmojiEntity -> Observable<CameraViewReactor.Mutation> in
                                                guard let updateEntity = updateRealEmojiEntity else { return .just(.setErrorAlert(true))}
                                                owner.provider.realEmojiGlobalState.updateRealEmojiImage(indexPath: owner.currentState.selectedIndexPath, image: updateEntity.realEmojiImageURL)
                                                return .concat(
                                                    .just(.setUpdateEmojiImage(updateEntity.realEmojiImageURL)),
                                                    .just(.setLoading(false)),
                                                    .just(.setErrorAlert(false))
                                                )
                                            }
                                    } else {
                                        return .empty()
                                    }
                                }
                            
                        }
                
                )
                
            }
        }
            
        
    }
    
}
