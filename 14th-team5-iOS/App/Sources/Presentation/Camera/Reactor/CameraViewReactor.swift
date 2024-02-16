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
        case didTapZoomButton(CGFloat)
        case didTapRealEmojiPad(IndexPath)
        case dragPreviewLayer(CGFloat)
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setPosition(Bool)
        case setFlashMode(Bool)
        case uploadImageToS3(Bool)
        case setAccountProfileData(Data)
        case setPinchZoomScale(CGFloat)
        case setZoomScale(CGFloat)
        case setProfileImageURLResponse(CameraDisplayImageResponse?)
        case setProfileMemberResponse(ProfileMemberResponse?)
        case setRealEmojiImageURLResponse(CameraRealEmojiPreSignedResponse?)
        case setRealEmojiImageCreateResponse(CameraCreateRealEmojiResponse?)
        case setRealEmojiItems(CameraRealEmojiImageItemResponse?)
        case setRealEmojiSection([EmojiSectionItem])
        case setErrorAlert(Bool)
        case setRealEmojiType(String)
        case setSelectedIndexPath(Int)
        case setRealEmojiImage([String: URL?])
        case setRealEmojiId([String: String])
        case setUpdateEmojiImage(URL)
    }
    
    public struct State {
        @Pulse var isLoading: Bool
        @Pulse var isFlashMode: Bool
        @Pulse var isSwitchPosition: Bool
        @Pulse var profileImageURLEntity: CameraDisplayImageResponse?
        @Pulse var realEmojiURLEntity: CameraRealEmojiPreSignedResponse?
        @Pulse var realEmojiCreateEntity: CameraCreateRealEmojiResponse?
        @Pulse var realEmojiEntity: CameraRealEmojiImageItemResponse?
        @Pulse var realEmojiSection: [EmojiSectionModel]
        @Pulse var reloadRealEmojiImage: [String: URL?]
        @Pulse var reloadRealEmojiId: [String: String]
        @Pulse var zoomScale: CGFloat
        @Pulse var pinchZoomScale: CGFloat
        var updateEmojiImage: URL?
        var emojiType: String
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
         memberId: String,
         emojiType: String = "EMOJI_1",
         emojiIndex: Int = 0
    ) {
        self.cameraType = cameraType
        self.cameraUseCase = cameraUseCase
        self.memberId = memberId
        self.provider = provider
        self.initialState = State(
            isLoading: true,
            isFlashMode: false,
            isSwitchPosition: false,
            profileImageURLEntity: nil,
            realEmojiURLEntity: nil,
            realEmojiCreateEntity: nil,
            realEmojiEntity: nil,
            realEmojiSection: [.realEmoji([])],
            reloadRealEmojiImage: [:],
            reloadRealEmojiId: [:],
            zoomScale: 1.0,
            pinchZoomScale: 1.0,
            updateEmojiImage: nil,
            emojiType: emojiType,
            selectedIndexPath: emojiIndex,
            cameraType: cameraType,
            accountImage: nil,
            memberId: memberId,
            isUpload: false,
            isError: false,
            profileMemberEntity: nil
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoadMutation()
            
        case .didTapToggleButton:
            return cameraUseCase.executeToggleCameraPosition(self.currentState.isSwitchPosition).map { .setPosition($0) }
        case .didTapFlashButton:
            return cameraUseCase.executeToggleCameraFlash(self.currentState.isFlashMode).map { .setFlashMode($0) }
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
            return .concat(
                .just(.setSelectedIndexPath(indexPath.row)),
                .just(.setRealEmojiType(Emojis.allEmojis[indexPath.row].emojiString))
            )
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
        case let .setRealEmojiImageCreateResponse(entity):
            newState.realEmojiCreateEntity = entity
        case let .setRealEmojiItems(items):
            newState.realEmojiEntity = items
        case let .setRealEmojiSection(section):
            let sectionIndex = getSection(.realEmoji([]))
            newState.realEmojiSection[sectionIndex] = .realEmoji(section)
        case let .setErrorAlert(isError):
            newState.isError = isError
        case let .setSelectedIndexPath(indexPath):
            newState.selectedIndexPath = indexPath
        case let .setRealEmojiType(emojiType):
            newState.emojiType = emojiType
        case let .setUpdateEmojiImage(realEmoji):
            newState.updateEmojiImage = realEmoji
        case let .setRealEmojiImage(reloadRealEmojiImage):
            newState.reloadRealEmojiImage = reloadRealEmojiImage
        case let .setRealEmojiId(reloadRealEmojiId):
            newState.reloadRealEmojiId = reloadRealEmojiId
        case let .setZoomScale(zoomScale):
            newState.zoomScale = zoomScale
        case let .setPinchZoomScale(pinchZoomScale):
            newState.pinchZoomScale = pinchZoomScale
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
        var searchImage: [String:URL?] = ["0":nil,"1":nil,"2":nil,"3":nil,"4":nil]
        var searchId: [String: String] = ["0":"","1":"","2":"","3":"","4":""]

        if cameraType == .realEmoji {
            return .concat(
                cameraUseCase.executeRealEmojiItems(memberId: memberId)
                    .withUnretained(self)
                    .flatMap { owner, entity -> Observable<CameraViewReactor.Mutation> in
                        var sectionItem: [EmojiSectionItem] = []
                        guard let realEmojiEntity = entity?.realEmojiItems else { return .just(.setErrorAlert(true))}
                        if realEmojiEntity.isEmpty {
                            CameraRealEmojiItems.allCases.enumerated().forEach {
                                let isSelected: Bool = $0.offset == owner.currentState.selectedIndexPath ? true : false
                                sectionItem.append(.realEmojiItem(
                                    BibbiRealEmojiCellReactor(
                                        provider: owner.provider,
                                        realEmojiImage: nil,
                                        defaultImage: $0.element.rawValue,
                                        isSelected: isSelected,
                                        indexPath: $0.offset,
                                        realEmojiId: "",
                                        realEmojiType: CameraRealEmojiItems.allCases[$0.offset].emojiType
                                    )
                                ))
                            }
                        } else {
                            
                            CameraRealEmojiItems.allCases.enumerated().forEach { item in
                                let index = CameraRealEmojiItems.allCases.firstIndex { emojiItem in
                                        return emojiItem.emojiType == realEmojiEntity[safe: item.offset]?.realEmojiType
                                } ?? -1
                                searchId["\(index)"] = realEmojiEntity[safe: item.offset]?.realEmojiId
                                searchImage["\(index)"] = realEmojiEntity[safe: item.offset]?.realEmojiImageURL
                            }
                            
                            CameraRealEmojiItems.allCases.enumerated().forEach { item in
                                let isSelected: Bool = item.offset == owner.currentState.selectedIndexPath ? true : false
                                sectionItem.append(.realEmojiItem(
                                    BibbiRealEmojiCellReactor(
                                        provider: owner.provider,
                                        realEmojiImage: searchImage["\(item.offset)"] as? URL,
                                        defaultImage: item.element.rawValue,
                                        isSelected: isSelected,
                                        indexPath: item.offset,
                                        realEmojiId: searchId["\(item.offset)"] ?? "",
                                        realEmojiType: realEmojiEntity[safe: item.offset]?.realEmojiType ?? ""
                                    )
                                ))

                            }
                        }
                        return .concat(
                            .just(.setLoading(false)),
                            .just(.setRealEmojiItems(entity)),
                            .just(.setRealEmojiSection(sectionItem)),
                            .just(.setRealEmojiImage(searchImage)),
                            .just(.setRealEmojiId(searchId)),
                            .just(.setErrorAlert(false)),
                            .just(.setLoading(true))
                        )
                        
                    }
            )
        } else {
            return .empty()
        }
    }
    
    private func didTapShutterButtonMutation(imageData: Data) -> Observable<CameraViewReactor.Mutation> {
      
        switch cameraType {
        case .feed, .profile:
            //Profile 관련 이미지 업로드 Mutation
            let profileImage = "\(imageData.hash).jpg"
            let profileParameter = CameraDisplayImageParameters(imageName: profileImage)
            
            return .concat(
                .just(.setLoading(false)),
                cameraUseCase.executeProfileImageURL(parameter: profileParameter, type: cameraType)
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .asObservable()
                    .flatMap { owner, entity -> Observable<CameraViewReactor.Mutation> in
                        //TODO: 추후 오류 Alert 추가
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
                                        .just(.setLoading(true))
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
                                                .just(.setLoading(true))
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

            if (currentState.reloadRealEmojiImage["\(currentState.selectedIndexPath)"] as? URL == nil) {
                return .concat(
                    .just(.setLoading(false)),
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
                                                        guard let orginalEntity = reloadEntity?.realEmojiItems else { return .just(.setErrorAlert(true)) }
                                                        var searchArray: [String:URL?] = ["0":nil,"1":nil,"2":nil,"3":nil,"4":nil]
                                                        var searchIdArray: [String: String] = ["0":"","1":"","2":"","3":"","4":""]
                                                        
                                                        CameraRealEmojiItems.allCases.enumerated().forEach { item in
                                                            let index = CameraRealEmojiItems.allCases.firstIndex { emojiItem in
                                                                return emojiItem.emojiType == orginalEntity[safe: item.offset]?.realEmojiType
                                                            } ?? -1
                                                            searchIdArray["\(index)"] = orginalEntity[safe: item.offset]?.realEmojiId
                                                            searchArray["\(index)"] = orginalEntity[safe: item.offset]?.realEmojiImageURL
                                                        }
                                                        
                                                        return .concat(
                                                            .just(.setRealEmojiImageURLResponse(entity)),
                                                            .just(.setRealEmojiItems(reloadEntity)),
                                                            .just(.uploadImageToS3(isSuccess)),
                                                            .just(.setRealEmojiId(searchIdArray)),
                                                            .just(.setRealEmojiImage(searchArray)),
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
                let realEmojiParameter = CameraRealEmojiParameters(imageName: realEmojiImage)
                return .concat(
                    .just(.setLoading(false)),
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
                                        return owner.cameraUseCase.executeUpdateRealEmojiImage(memberId: owner.memberId, realEmojiId: owner.currentState.reloadRealEmojiId["\(owner.currentState.selectedIndexPath)"] ?? "", parameter: updateRealEmojiParameter)
                                            .asObservable()
                                            .flatMap { updateRealEmojiEntity -> Observable<CameraViewReactor.Mutation> in
                                                guard let updateEntity = updateRealEmojiEntity else { return .just(.setErrorAlert(true))}
                                                owner.provider.realEmojiGlobalState.updateRealEmojiImage(indexPath: owner.currentState.selectedIndexPath, image: updateEntity.realEmojiImageURL)
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
