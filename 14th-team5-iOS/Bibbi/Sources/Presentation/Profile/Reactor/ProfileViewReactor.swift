//
//  ProfileViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/17/23.
//

import Foundation

import Core
import Domain
import Util
import ReactorKit


public final class ProfileViewReactor: Reactor {
    public var initialState: State
    
    @Injected private var fetchMembersProfileUseCase: FetchMembersProfileUseCaseProtocol
    @Injected private var updateMembersProfileUseCase: UpdateMembersProfileUseCaseProtocol
    @Injected private var uploadProfileImageUseCase: FetchCameraUploadImageUseCaseProtocol
    @Injected private var createPresignedURLUseCase: CreateMembersPresignedURLUseCaseProtocol
    @Injected private var deleteProfileImageUseCase: DeleteMembersProfileUseCaseProtocol
    @Navigator private var profileNavigator: ProfileNavigatorProtocol
    
    
    private let memberId: String
    private let isUser: Bool
    @Injected private var provider: ServiceProviderProtocol
    
    public enum Action {
        case viewDidLoad
        case viewWillAppear
        case viewDidDisappear
        case didSelectPHAssetsImage(Data)
        case didTapInitProfile
        case didTappedProfileEditButton(String)
        case didTappedProfileImageView(URL, String)
        case didTappedNavigationButton(String)
        case didTappedAlertButton(String)
        case didTapSegementControl(BibbiFeedType)
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setProfileMemberItems(MembersProfileEntity?)
        case setProfileFeedType(BibbiFeedType)
    }
    
    public struct State {
        var isLoading: Bool
        var memberId: String
        var isUser: Bool
        var feedType: BibbiFeedType
        @Pulse var profileMemberEntity: MembersProfileEntity?
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
            let body = CreateMemberPresignedReqeust(imageName: imageName)
            
            return createPresignedURLUseCase.execute(body: body, imageData: assetImage)
                .withUnretained(self)
                .flatMap { owner, entity -> Observable<Mutation> in
                    guard let presignedURL = entity?.imageURL else {
                        return .error(BBUploadError.invalidServerResponse)
                    }
                    let updateImageURL = owner.configureProfileOriginalS3URL(url: presignedURL)
                    let body = UpdateMemberImageRequest(profileImageUrl: updateImageURL)
                    return owner.updateMembersProfileUseCase.execute(memberId: owner.memberId, body: body)
                        .flatMap { entity -> Observable<Mutation> in
                            return .concat(
                                .just(.setLoading(false)),
                                .just(.setProfileMemberItems(entity)),
                                .just(.setLoading(true))
                            )
                        }
                }.catch { [weak self] error in
                    self?.profileNavigator.showErrorToast(error.localizedDescription)
                    return .empty()
                }
  
        case .didTapInitProfile:
            return deleteProfileImageUseCase.execute(memberId: memberId)
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
        case let .didTappedProfileImageView(imageURL, nickName):
            profileNavigator.toProfileDetail(imageURL, nickName: nickName)
            return .empty()
        case let .didTappedNavigationButton(memberId):
            profileNavigator.toPrivacy(memberId)
            return .empty()
        case let .didTappedProfileEditButton(memberId):
            BBLogManager.analytics(logType: BBEventAnalyticsLog.clickAccountButton(entry: .profileNickNameEdit))
            profileNavigator.toAccountNickname(memberId)
            return .empty()
        case let .didTappedAlertButton(memberId):
            profileNavigator.toCamera(memberId)
            return .empty()
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
