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
        case setProfileS3Edit(Bool)
        case setProfileImageURLResponse(CameraDisplayImageResponse?)
        case setProfileMemberResponse(ProfileMemberResponse?)
    }
    
    public struct State {
        var isLoading: Bool
        @Pulse var isFlashMode: Bool
        @Pulse var isSwitchPosition: Bool
        @Pulse var profileImageURLEntity: CameraDisplayImageResponse?
        var cameraType: UploadLocation = .feed
        var memberId: String
        var isProfileEdit: Bool
        var profileMemberEntity: ProfileMemberResponse?
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
            cameraType: self.cameraType,
            memberId: self.memberId,
            isProfileEdit: false,
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
            let profileImage = "\(fileData.hashValue).jpg"
            print("didTapShuuterButton Test: \(profileImage)")
            let profileEditParameter: CameraDisplayImageParameters = CameraDisplayImageParameters(imageName: profileImage)
            return .concat(
                .just(.setLoading(true)),
                // presignedURL 요청
                cameraUseCase.executeProfileImageURL(parameter: profileEditParameter, type: cameraType)
                    .withUnretained(self)
                    .asObservable()
                    .flatMap { owner, entity -> Observable<CameraViewReactor.Mutation> in
                        // presignedURL에 image Upload
                        return owner.cameraUseCase.executeProfileUploadToS3(toURL: entity?.imageURL ?? "", imageData: fileData)
                            .asObservable()
                            .flatMap { isSuccess -> Observable<CameraViewReactor.Mutation> in
                                print("check PresingedURL: \(entity?.imageURL)")
                                guard let profilePresingedURL = entity?.imageURL else { return .empty() }
                                
                                let originalURL = owner.configureProfileOriginalS3URL(url: profilePresingedURL, with: .profile)
                                let profileImageEditParameter: ProfileImageEditParameter = ProfileImageEditParameter(profileImageUrl: originalURL)
                                if isSuccess {
                                    return owner.cameraUseCase.executeEditProfileImage(memberId: owner.memberId, parameter: profileImageEditParameter)
                                        .asObservable()
                                        .flatMap { editEntity -> Observable<CameraViewReactor.Mutation> in
                                            print("edit Entity: \(editEntity)")
                                            return .concat(
                                                .just(.setProfileImageURLResponse(entity)),
                                                .just(.setProfileS3Edit(isSuccess)),
                                                .just(.setProfileMemberResponse(editEntity)),
                                                .just(.setLoading(false))
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
            print("newState profileimageURL: \(newState.profileImageURLEntity)")
        case let .setProfileS3Edit(isProfileEdit):
            newState.isProfileEdit = isProfileEdit
            print("newState isProfileEdit: \(newState.isProfileEdit)")
        case let .setProfileMemberResponse(entity):
            newState.profileMemberEntity = entity
            print("newState profileMemberEnity: \(newState.profileMemberEntity)")
        }
        
        return newState
    }
    
}

extension CameraViewReactor {
    
    func configureProfileOriginalS3URL(url: String, with filePath: UploadLocation) -> String {
        guard let range = url.range(of: #"[^&?]+"#, options: .regularExpression) else { return "" }
        return String(url[range])
    }
    
}
