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
    
    
    @Injected private var uploadImageUseCase: FetchCameraUploadImageUseCaseProtocol
    @Injected private var fetchDailyMissionUseCase: FetchDailyMissonContentUseCaseProtocol
    @Injected private var fetchRealEmojiUpdateUseCase: FetchCameraRealEmojiUpdateUseCaseProtocol
    @Injected private var fetchRealEmojiCreateUseCase: FetchCameraRealEmojiUploadUseCaseProtocol
    @Injected private var fetchRealEmojiListUseCase: FetchCameraRealEmojiListUseCaseProtocol
    @Injected private var fetchRealEmojiPreSignedUseCase: FetchCameraRealEmojiUseCaseProtocol
    @Injected private var fetchMyMemberIdUseCase: FetchMyMemberIdUseCaseProtocol
    @Injected private var provider: ServiceProviderProtocol
    @Injected private var createPresignedURLUseCase: CreateMembersPresignedURLUseCaseProtocol
    @Injected private var updateMembersProfileUseCase: UpdateMembersProfileUseCaseProtocol
    @Navigator var cameraNavigator: CameraNavigatorProtocol
    
    public var cameraType: UploadLocation
    public var memberId: String
    
    public enum Action {
        case viewDidLoad
        case didTapFlashButton
        case didTapToggleButton
        case didTapShutterButton(Data)
        case didTapZoomButton(CGFloat)
        case didTapRealEmojiPad(IndexPath)
        case dragPreviewLayer(CGFloat)
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setPosition(Bool)
        case setFlashMode(Bool)
        case setPinchZoomScale(CGFloat)
        case setZoomScale(CGFloat)
        case setDailyMissionrResponse(MissonTodayContentEntity?)
        case setProfilePresignedResponse(CreateMemberPresignedEntity?)
        case setProfileMemberResponse(MembersProfileEntity?)
        case setRealEmojiImageURLResponse(CameraRealEmojiPreSignedEntity?)
        case setRealEmojiImageCreateResponse(CameraCreateRealEmojiEntity?)
        case setRealEmojiItems([CameraRealEmojiImageItemEntity?])
        case setRealEmojiSection([EmojiSectionItem])
        case setErrorAlert(Bool)
        case setRealEmojiType(Emojis)
        case setImageData(Data)
        case setUpdateEmojiImage(URL)
    }
    
    public struct State {
        @Pulse var isLoading: Bool
        @Pulse var isFlashMode: Bool
        @Pulse var isSwitchPosition: Bool
        @Pulse var missionEntity: MissonTodayContentEntity?
        @Pulse var memberPresignedEntity: CreateMemberPresignedEntity?
        @Pulse var realEmojiURLEntity: CameraRealEmojiPreSignedEntity?
        @Pulse var realEmojiCreateEntity: CameraCreateRealEmojiEntity?
        @Pulse var realEmojiEntity: [CameraRealEmojiImageItemEntity?]
        @Pulse var realEmojiSection: [EmojiSectionModel]
        @Pulse var zoomScale: CGFloat
        @Pulse var pinchZoomScale: CGFloat
        @Pulse var imageData: Data?
        var updateEmojiImage: URL?
        var emojiType: Emojis = .emoji(forIndex: 1)
        @Pulse var cameraType: UploadLocation = .survival
        var accountImage: Data?
        var memberId: String
        @Pulse var isError: Bool
        @Pulse var profileMemberEntity: MembersProfileEntity?
    }
    
    init(
        cameraType: UploadLocation,
        memberId: String,
        emojiType: Emojis = .emoji(forIndex: 1)
    ) {
        self.cameraType = cameraType
        self.memberId = memberId
        self.initialState = State(
            isLoading: true,
            isFlashMode: false,
            isSwitchPosition: false,
            realEmojiEntity: [],
            realEmojiSection: [.realEmoji([])],
            zoomScale: 1.0,
            pinchZoomScale: 1.0,
            emojiType: emojiType,
            cameraType: cameraType,
            memberId: memberId,
            isError: false
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoadMutation()
            
        case .didTapToggleButton:
            return Observable.just(.setPosition(!self.currentState.isSwitchPosition))
        case .didTapFlashButton:
            return Observable.just(.setFlashMode(!self.currentState.isFlashMode))
        case let .didTapZoomButton(scale):
            if self.currentState.zoomScale == 2.0 {
                return .just(.setZoomScale(self.currentState.zoomScale - scale))
            } else {
                return .just(.setZoomScale(self.currentState.zoomScale + scale))
            }
            
        case let .didTapShutterButton(fileData):
            return didTapShutterButtonMutation(imageData: fileData)
            
        case let .didTapRealEmojiPad(indexPath):
            provider.realEmojiGlobalState.didTapRealEmojiEvent(indexPath: indexPath.row)
            return .just(.setRealEmojiType(Emojis.allEmojis[indexPath.row]))
        case let .dragPreviewLayer(scale):
            let minAvailableZoomScale: CGFloat = 1.0
            let maxAvailableZoomScale: CGFloat = 10.0
            let availableZoomScaleRange = minAvailableZoomScale...maxAvailableZoomScale
            let zoomScaleRange: ClosedRange<CGFloat> = 1...10
            let resolvedZoomScaleRange = zoomScaleRange.clamped(to: availableZoomScaleRange)
            
            return .just(.setPinchZoomScale(max(resolvedZoomScaleRange.lowerBound, min(scale  * self.currentState.pinchZoomScale, resolvedZoomScaleRange.upperBound))))
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
        case let .setProfileMemberResponse(entity):
            newState.profileMemberEntity = entity
        case let .setRealEmojiImageURLResponse(entity):
            newState.realEmojiURLEntity = entity
        case let .setRealEmojiImageCreateResponse(entity):
            newState.realEmojiCreateEntity = entity
        case let .setRealEmojiItems(items):
            newState.realEmojiEntity = items
        case let .setRealEmojiSection(section):
            let sectionIndex = getSection(.realEmoji([]))
            newState.realEmojiSection[sectionIndex] = .realEmoji(section)
        case let .setErrorAlert(isError):
            newState.isError = isError
        case let .setRealEmojiType(emojiType):
            newState.emojiType = emojiType
        case let .setUpdateEmojiImage(realEmoji):
            newState.updateEmojiImage = realEmoji
        case let .setZoomScale(zoomScale):
            newState.zoomScale = zoomScale
        case let .setPinchZoomScale(pinchZoomScale):
            newState.pinchZoomScale = pinchZoomScale
        case let .setImageData(feedImage):
            newState.imageData = feedImage
        case let .setProfilePresignedResponse(memberPresignedEntity):
            newState.memberPresignedEntity = memberPresignedEntity
        case let .setDailyMissionrResponse(missionEntity):
            newState.missionEntity = missionEntity
        }
        
        return newState
    }
    
}

extension CameraViewReactor {
    
    private func getSection(_ section: EmojiSectionModel) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.realEmojiSection.count where self.currentState.realEmojiSection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
    
    private func configureProfileOriginalS3URL(url: String, with filePath: UploadLocation) -> String {
        guard let range = url.range(of: #"[^&?]+"#, options: .regularExpression) else { return "" }
        return String(url[range])
    }
    
    private func viewDidLoadMutation() -> Observable<CameraViewReactor.Mutation> {
        switch cameraType {
        case .realEmoji:
            
            guard let memberId = fetchMyMemberIdUseCase.execute() else {
                return .just(.setErrorAlert(true))
            }
            
            return .concat(
                fetchRealEmojiListUseCase.execute(memberId: memberId)
                    .withUnretained(self)
                    .flatMap { owner, entity -> Observable<CameraViewReactor.Mutation> in
                        var sectionItem: [EmojiSectionItem] = []
                        entity.enumerated().forEach {
                            
                            let isSelected: Bool = $0.offset == (owner.currentState.emojiType.rawValue - 1) ? true : false
                            sectionItem.append(
                                .realEmojiItem(
                                    BibbiRealEmojiCellReactor(
                                        provider: owner.provider,
                                        realEmojiImage: $0.element?.realEmojiImageURL,
                                        isSelected: isSelected,
                                        indexPath: $0.offset,
                                        realEmojiId: $0.element?.realEmojiId ?? "",
                                        realEmojiType: $0.element?.realEmojiType ?? ""
                                    )
                                )
                                
                            )
                        }
                        return .concat(
                            .just(.setLoading(false)),
                            .just(.setRealEmojiItems(entity)),
                            .just(.setRealEmojiSection(sectionItem)),
                            .just(.setErrorAlert(false)),
                            .just(.setLoading(true))
                        )
                        
                    }
            )
        case .mission:
            return fetchDailyMissionUseCase.execute()
                .flatMap { entity -> Observable<Mutation> in
                    return .concat(
                        .just(.setLoading(false)),
                        .just(.setDailyMissionrResponse(entity)),
                        .just(.setLoading(true))
                    )
                }
        default:
            return .empty()
        }
    }
    
    private func didTapShutterButtonMutation(imageData: Data) -> Observable<CameraViewReactor.Mutation> {
        
        switch cameraType {
        case .survival, .mission:
            return .concat(
                .just(.setLoading(false)),
                .just(.setImageData(imageData)),
                .just(.setLoading(true))
            )
            
        case .account:
            let profileImage = "\(imageData.hashValue).jpg"
            let body = CreateMemberPresignedReqeust(imageName: profileImage)
            
            return createPresignedURLUseCase.execute(body: body, imageData: imageData)
                .flatMap { entity -> Observable<Mutation> in
                    guard let _ = entity?.imageURL else {
                        return .error(BBUploadError.invalidServerResponse)
                    }
                    
                    return .concat(
                        .just(.setLoading(false)),
                        .just(.setProfilePresignedResponse(entity)),
                        .just(.setImageData(imageData)),
                        .just(.setLoading(true))
                    )
                }.catch { [weak self] error in
                    self?.cameraNavigator.showErrorToast(error.localizedDescription)
                    return .empty()
                }
        case  .profile:
            let profileImage = "\(imageData.hashValue).jpg"
            let body = CreateMemberPresignedReqeust(imageName: profileImage)
            
            return createPresignedURLUseCase.execute(body: body, imageData: imageData)
                .withUnretained(self)
                .flatMap { owner, entity -> Observable<Mutation> in
                    guard let presignedURL = entity?.imageURL else {
                        return .error(BBUploadError.invalidServerResponse)
                    }
                    let updateImageURL = owner.configureProfileOriginalS3URL(url: presignedURL, with: .profile)
                    let body = UpdateMemberImageRequest(profileImageUrl: updateImageURL)
                    return owner.updateMembersProfileUseCase.execute(memberId: owner.memberId, body: body)
                        .flatMap { entity -> Observable<Mutation> in
                            return .concat(
                                .just(.setLoading(false)),
                                .just(.setProfileMemberResponse(entity)),
                                .just(.setLoading(true))
                            )
                        }.catch { [weak self] error in
                            self?.cameraNavigator.showErrorToast(error.localizedDescription)
                            return .empty()
                        }
                }.catch { [weak self] error in
                    self?.cameraNavigator.showErrorToast(error.localizedDescription)
                    return .empty()
                }
        case .realEmoji:
            guard let memberId = fetchMyMemberIdUseCase.execute() else {
                return .just(.setErrorAlert(true))
            }
            
            let realEmojiImage = "\(imageData.hashValue).jpg"
            let body = CreatePresignedURLRequest(imageName: realEmojiImage)
            if currentState.realEmojiEntity[currentState.emojiType.rawValue - 1] == nil {
                return .concat(
                    .just(.setLoading(false)),
                    fetchRealEmojiPreSignedUseCase.execute(memberId: memberId, body: body)
                        .withUnretained(self)
                        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                        .flatMap { owner, entity -> Observable<CameraViewReactor.Mutation> in
                            guard let remoteURL = entity?.imageURL else { return .just(.setErrorAlert(true))}
                            
                            return owner.uploadImageUseCase.execute(remoteURL, image: imageData)
                                .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                .flatMap { isSuccess -> Observable<CameraViewReactor.Mutation> in
                                    let originalURL = owner.configureProfileOriginalS3URL(url: remoteURL, with: .realEmoji)
                                    let body = CreateEmojiImageRequest(type: owner.currentState.emojiType.emojiString, imageUrl: originalURL)
                                    if isSuccess {
                                        return owner.fetchRealEmojiCreateUseCase.execute(memberId: memberId, body: body)
                                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                            .flatMap { realEmojiEntity -> Observable<CameraViewReactor.Mutation> in
                                                guard let createRealEmojiEntity = realEmojiEntity else { return .just(.setErrorAlert(true))}
                                                owner.provider.realEmojiGlobalState.createRealEmojiImage(indexPath: owner.currentState.emojiType.rawValue - 1, image: createRealEmojiEntity.realEmojiImageURL, emojiType: createRealEmojiEntity.realEmojiType)
                                                return owner.fetchRealEmojiListUseCase.execute(memberId: memberId)
                                                    .asObservable()
                                                    .flatMap { reloadEntity -> Observable<CameraViewReactor.Mutation> in
                                                        return .concat(
                                                            .just(.setRealEmojiImageURLResponse(entity)),
                                                            .just(.setRealEmojiItems(reloadEntity)),
                                                            .just(.setRealEmojiImageCreateResponse(realEmojiEntity)),
                                                            .just(.setErrorAlert(false)),
                                                            .just(.setLoading(true))
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
                let body = CreatePresignedURLRequest(imageName: realEmojiImage)
                return .concat(
                    .just(.setLoading(false)),
                    fetchRealEmojiPreSignedUseCase.execute(memberId: memberId, body: body)
                        .withUnretained(self)
                        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                        .flatMap { owner, entity -> Observable<CameraViewReactor.Mutation> in
                            guard let remoteURL = entity?.imageURL else { return .just(.setErrorAlert(true))}
                            let originalURL = owner.configureProfileOriginalS3URL(url: remoteURL, with: .realEmoji)
                            
                            return owner.uploadImageUseCase.execute(remoteURL, image: imageData)
                                .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                .asObservable()
                                .flatMap { isSuccess -> Observable<CameraViewReactor.Mutation> in
                                    if isSuccess {
                                        let body = UpdateRealEmojiImageRequest(imageUrl: originalURL)
                                        return owner.fetchRealEmojiUpdateUseCase.execute(memberId: memberId, realEmojiId: owner.currentState.realEmojiEntity[owner.currentState.emojiType.rawValue - 1]?.realEmojiId ?? "", body: body)
                                            .flatMap { updateRealEmojiEntity -> Observable<CameraViewReactor.Mutation> in
                                                guard let updateEntity = updateRealEmojiEntity else { return .just(.setErrorAlert(true))}
                                                owner.provider.realEmojiGlobalState.updateRealEmojiImage(indexPath: owner.currentState.emojiType.rawValue - 1, image: updateEntity.realEmojiImageURL)
                                                return .concat(
                                                    .just(.setUpdateEmojiImage(updateEntity.realEmojiImageURL)),
                                                    .just(.setLoading(true)),
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
