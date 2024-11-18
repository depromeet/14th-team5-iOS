//
//  ProfileViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/17/23.
//

import Foundation

import Core
import Domain
import ReactorKit


public final class ProfileViewReactor: Reactor {
    public var initialState: State
    
    @Injected private var fetchMembersProfileUseCase: FetchMembersProfileUseCaseProtocol
    @Injected private var createProfilePresignedUseCase: CreateCameraUseCaseProtocol
    @Injected private var uploadProfileImageUseCase: FetchCameraUploadImageUseCaseProtocol
    @Injected private var updateProfileUseCase: UpdateMembersProfileUseCaseProtocol
    @Injected private var deleteProfileImageUseCase: DeleteMembersProfileUseCaseProtocol
    
    
    
    private let memberId: String
    private let isUser: Bool
    @Injected private var provider: ServiceProviderProtocol
    
    public enum Action {
        case viewDidLoad
        case viewWillAppear
        case viewDidDisappear
        case updateNickNameProfile(Data)
        case didSelectPHAssetsImage(Data)
        case didTapInitProfile
        case didTapSegementControl(BibbiFeedType)
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setProfilePresingedURL(CameraPreSignedEntity?)
        case setProfileMemberItems(MembersProfileEntity?)
        case setProfileFeedType(BibbiFeedType)
    }
    
    public struct State {
        var isLoading: Bool
        var memberId: String
        var isUser: Bool
        var feedType: BibbiFeedType
        @Pulse var profileMemberEntity: MembersProfileEntity?
        @Pulse var profilePresingedURLEntity: CameraPreSignedEntity?
    }
    
    init(
        memberId: String,
        isUser: Bool
    ) {
        self.memberId = memberId
        self.isUser = isUser
        self.initialState = State(
            isLoading: true,
            memberId: memberId,
            isUser: isUser,
            feedType: .survival
        )
        
        self.provider = provider
    }
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let segmentedUpdateMutation = provider.profilePageGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .didReceiveMemberId(type):
                    return .just(.setProfileFeedType(type))
                default:
                    return .empty()
                }
            }
        return .merge(mutation, segmentedUpdateMutation)
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchMembersProfileUseCase.execute(memberId: currentState.memberId)
                .asObservable()
                .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
                    .just(.setProfileMemberItems(entity))
            }
        case let .updateNickNameProfile(imageData):
            let profileImage = "\(imageData.hashValue).jpg"
            let createPresignedURL = CreatePresignedURLRequest(imageName: profileImage)
            return .concat(
                .just(.setLoading(false)),
                createProfilePresignedUseCase.execute(body: createPresignedURL)
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .flatMap { owner, entity -> Observable<ProfileViewReactor.Mutation> in
                        guard let remoteURL = entity?.imageURL else { return .empty() }
                        return owner.uploadProfileImageUseCase.execute(remoteURL, image: imageData)
                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .flatMap { isSuccess -> Observable<ProfileViewReactor.Mutation> in
                                let originalPath = owner.configureProfileOriginalS3URL(url: remoteURL)
                                let profileEditParameter: ProfileImageEditParameter = ProfileImageEditParameter(profileImageUrl: originalPath)
                                if isSuccess {
                                    return owner.updateProfileUseCase.execute(memberId: owner.currentState.memberId, parameter: profileEditParameter)
                                        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                        .asObservable()
                                        .flatMap { memberEntity -> Observable<ProfileViewReactor.Mutation> in
                                            return .concat(
                                                .just(.setProfilePresingedURL(entity)),
                                                .just(.setProfileMemberItems(memberEntity)),
                                                .just(.setLoading(true))
                                                
                                            )
                                        }
                                } else {
                                    return .empty()
                                }
                                
                            }
                    })
            
        case .viewWillAppear:
            return fetchMembersProfileUseCase.execute(memberId: currentState.memberId)
                .asObservable()
                .withUnretained(self)
                .flatMap { owner ,entity -> Observable<ProfileViewReactor.Mutation> in
                        .concat(
                            .just(.setLoading(false)),
                            .just(.setProfileMemberItems(entity)),
                            .just(.setLoading(true))
                        )
                }
        
        case let .didSelectPHAssetsImage(assetImage):
            let imageName: String = "\(assetImage.hashValue).jpg"
            let createPresignedURL = CreatePresignedURLRequest(imageName: imageName)
            return .concat(
                .just(.setLoading(false)),
                createProfilePresignedUseCase.execute(body: createPresignedURL)
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .flatMap { owner, entity -> Observable<ProfileViewReactor.Mutation> in
                        guard let remoteURL = entity?.imageURL else { return .empty() }
                        return owner.uploadProfileImageUseCase.execute(remoteURL, image: assetImage)
                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .flatMap { isSuccess -> Observable<ProfileViewReactor.Mutation> in
                                let originalPath = owner.configureProfileOriginalS3URL(url: remoteURL)
                                let profileEditParameter: ProfileImageEditParameter = ProfileImageEditParameter(profileImageUrl: originalPath)
                                if isSuccess {
                                    return owner.updateProfileUseCase.execute(memberId: owner.currentState.memberId, parameter: profileEditParameter)
                                        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                        .asObservable()
                                        .flatMap { memberEntity -> Observable<ProfileViewReactor.Mutation> in
                                            return .concat(
                                                .just(.setProfilePresingedURL(entity)),
                                                .just(.setProfileMemberItems(memberEntity)),
                                                .just(.setLoading(true))
                                                
                                            )
                                        }
                                    
                                } else {
                                    return .empty()
                                }
                                
                            }
                    }
            )
        case .didTapInitProfile:
            return deleteProfileImageUseCase.execute(memberId: memberId)
                .asObservable()
                .flatMap { entity -> Observable<Mutation> in
                    return .concat(
                        .just(.setLoading(false)),
                        .just(.setProfileMemberItems(entity)),
                        .just(.setLoading(true))
                    )
                }
        case let .didTapSegementControl(feedType):
            provider.profilePageGlobalState.didTapSegmentedPageType(type: feedType)
            return .just(.setProfileFeedType(feedType))
        case .viewDidDisappear:
            return provider.mainService.refreshMain()
                .flatMap { _ in Observable<Mutation>.empty() }
        }
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        
        case let .setProfileMemberItems(entity):
            provider.managementService.didUpdateFamilyInfo()
            newState.profileMemberEntity = entity
            
        case let .setProfilePresingedURL(entity):
            newState.profilePresingedURLEntity = entity

        case let .setProfileFeedType(feedType):
            newState.feedType = feedType
        }
        
        return newState
    }
    
}


extension ProfileViewReactor {
 
    
    func configureProfileOriginalS3URL(url: String) -> String {
        guard let range = url.range(of: #"[^&?]+"#, options: .regularExpression) else { return "" }
        return String(url[range])
    }
    
}
