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
    
    private let fetchMembersProfileUseCase: FetchMembersProfileUseCaseProtocol
    private let createProfilePresignedUseCase: CreateCameraUseCaseProtocol
    private let uploadProfileImageUseCase: FetchCameraUploadImageUseCaseProtocol
    private let updateProfileUseCase: UpdateMembersProfileUseCaseProtocol
    
    
    
    private let memberId: String
    private let isUser: Bool
    private let provider: GlobalStateProviderProtocol
    
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
        fetchMembersProfileUseCase: FetchMembersProfileUseCaseProtocol,
        createProfilePresignedUseCase: CreateCameraUseCaseProtocol,
        uploadProfileImageUseCase: FetchCameraUploadImageUseCaseProtocol,
        updateProfileUseCase: UpdateMembersProfileUseCaseProtocol,
        provider: GlobalStateProviderProtocol,
        memberId: String,
        isUser: Bool
    ) {
        self.fetchMembersProfileUseCase = fetchMembersProfileUseCase
        self.createProfilePresignedUseCase = createProfilePresignedUseCase
        self.uploadProfileImageUseCase = uploadProfileImageUseCase
        self.updateProfileUseCase = updateProfileUseCase
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
        //TODO: Keychain, UserDefaults 추가
        switch action {
        case .viewDidLoad:
            return fetchMembersProfileUseCase.execute(memberId: currentState.memberId)
                .asObservable()
                .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
                    .just(.setProfileMemberItems(entity))
            }
        case let .updateNickNameProfile(nickNameFileData):
            let nickNameProfileImage: String = "\(nickNameFileData.hashValue).jpg"
            let nickNameImageEditParameter: CameraDisplayImageParameters = CameraDisplayImageParameters(imageName: nickNameProfileImage)
            return .concat(
                .just(.setLoading(false)),
                createProfilePresignedUseCase.execute(parameter: nickNameImageEditParameter)
                    .asObservable()
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .flatMap { owner, entity -> Observable<ProfileViewReactor.Mutation> in
                        guard let profilePresingedURL = entity?.imageURL else { return .empty() }
                        return owner.uploadProfileImageUseCase.execute(to: profilePresingedURL, from: nickNameFileData)
                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .asObservable()
                            .flatMap { isSuccess -> Observable<ProfileViewReactor.Mutation> in
                                let originalPath = owner.configureProfileOriginalS3URL(url: profilePresingedURL)
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
        
        case let .didSelectPHAssetsImage(fileData):
            let profileImage: String = "\(fileData.hashValue).jpg"
            let profileImageEditParameter: CameraDisplayImageParameters = CameraDisplayImageParameters(imageName: profileImage)
            return .concat(
                .just(.setLoading(false)),
                createProfilePresignedUseCase.execute(parameter: profileImageEditParameter)
                    .asObservable()
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .flatMap { owner, entity -> Observable<ProfileViewReactor.Mutation> in
                        guard let profilePresingedURL = entity?.imageURL else { return .empty() }
                        return owner.uploadProfileImageUseCase.execute(to: profilePresingedURL, from: fileData)
                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .asObservable()
                            .flatMap { isSuccess -> Observable<ProfileViewReactor.Mutation> in
                                let originalPath = owner.configureProfileOriginalS3URL(url: profilePresingedURL)
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
            return fetchMembersProfileUseCase.execute(memberId: memberId)
                .asObservable()
                .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
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
            provider.profileGlobalState.refreshFamilyMembers()
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
