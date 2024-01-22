//
//  CameraViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

import Domain
import Data
import ReactorKit


public final class CameraViewReactor: Reactor {
    
    public var initialState: State
    private var cameraUseCase: CameraViewUseCaseProtocol
    public var cameraType: UploadLocation
    public var memberId: String
    
    public enum Action {
        case didTapFlashButton
        case didTapToggleButton
        case didTapShutterButton(Data)
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
        case setErrorAlert(Bool)
    }
    
    public struct State {
        var isLoading: Bool
        @Pulse var isFlashMode: Bool
        @Pulse var isSwitchPosition: Bool
        @Pulse var profileImageURLEntity: CameraDisplayImageResponse?
        @Pulse var realEmojiURLEntity: CameraRealEmojiPreSignedResponse?
        @Pulse var realEmojiCreateEntity: CameraCreateRealEmojiResponse?
        @Pulse var realEmojiEntity: CameraRealEmojiImageItemResponse?
        var cameraType: UploadLocation = .feed
        var accountImage: Data?
        var memberId: String
        var isUpload: Bool
        var isError: Bool
        @Pulse var profileMemberEntity: ProfileMemberResponse?
    }
    
    init(cameraUseCase: CameraViewUseCaseProtocol,
         cameraType: UploadLocation,
         memberId: String
    ) {
        self.cameraType = cameraType
        self.cameraUseCase = cameraUseCase
        self.memberId = memberId
        self.initialState = State(
            isLoading: false,
            isFlashMode: false,
            isSwitchPosition: false,
            profileImageURLEntity: nil,
            realEmojiURLEntity: nil,
            realEmojiCreateEntity: nil,
            realEmojiEntity: nil,
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
        case .didTapToggleButton:
            return cameraUseCase.executeToggleCameraPosition(self.currentState.isSwitchPosition).map { .setPosition($0) }
        case .didTapFlashButton:
            return cameraUseCase.executeToggleCameraFlash(self.currentState.isFlashMode).map { .setFlashMode($0) }
            
        case let .didTapShutterButton(fileData):
            return didTapShutterButtonMutation(imageData: fileData)
            
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
            newState.realEmojiEntity = items
        case let .setErrorAlert(isError):
            newState.isError = isError
        }
        
        return newState
    }
    
}

extension CameraViewReactor {
    
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
            //TODO:  Emoji Type을 별도로 받아야함 이걸 통해서 몇번째에 Image 변경해야하는지 분기 처리
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
                        
                        return owner.cameraUseCase.executeUploadToS3(toURL: presingedURL, imageData: imageData)
                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .asObservable()
                            .flatMap { isSuccess -> Observable<CameraViewReactor.Mutation> in
                                
                                let originalURL = owner.configureProfileOriginalS3URL(url: presingedURL, with: .realEmoji)
                                let realEmojiCreateParameter = CameraCreateRealEmojiParameters(type: "EMOJI_1", imageUrl: originalURL)
                                
                                if isSuccess {
                                    return owner.cameraUseCase.executeRealEmojiUploadToS3(memberId: owner.memberId, parameter: realEmojiCreateParameter)
                                        .asObservable()
                                        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                        .flatMap { realEmojiEntity -> Observable<CameraViewReactor.Mutation> in
                                            return .concat(
                                                .just(.setRealEmojiImageURLResponse(entity)),
                                                .just(.uploadImageToS3(isSuccess)),
                                                .just(.setRealEmojiImageCreateResponse(realEmojiEntity)),
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

        }
        
    }
    
}


//Real Emoji 촬영이 끝날때마다 조회 API호출해서 Reload 하도록 해야함
