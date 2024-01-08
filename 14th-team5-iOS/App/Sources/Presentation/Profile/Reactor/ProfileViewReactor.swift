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
    private let profileUseCase: ProfileViewUsecaseProtocol
    private let memberId: String
    private let isUser: Bool
    
    public enum Action {
        case viewDidLoad
        case viewWillAppear
        case fetchMorePostItems(Bool)
        case didSelectPHAssetsImage(Data)
        case didTapInitProfile(Data)
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setProfilePresingedURL(CameraDisplayImageResponse?)
        case setPresignedS3Upload(Bool)
        case setFeedCategroySection([ProfileFeedSectionItem])
        case setProfileMemberItems(ProfileMemberResponse?)
        case setProfilePostItems(ProfilePostResponse)
    }
    
    public struct State {
        var isLoading: Bool
        var memberId: String
        var isUser: Bool
        @Pulse var feedSection: [ProfileFeedSectionModel]
        @Pulse var profileMemberEntity: ProfileMemberResponse?
        @Pulse var profilePostEntity: ProfilePostResponse?
        @Pulse var isProfileUpload: Bool
        @Pulse var profilePresingedURLEntity: CameraDisplayImageResponse?
    }
    
    init(profileUseCase: ProfileViewUsecaseProtocol, memberId: String, isUser: Bool) {
        self.profileUseCase = profileUseCase
        self.memberId = memberId
        self.isUser = isUser
        self.initialState = State(
            isLoading: false,
            memberId: memberId,
            isUser: isUser,
            feedSection: [.feedCategory([])],
            profileMemberEntity: nil,
            isProfileUpload: false,
            profilePresingedURLEntity: nil
        )
        
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        //TODO: Keychain, UserDefaults 추가
        //currentState는 선택된 내 멤버아이디임 분기처리 필요 x
        
        var query: ProfilePostQuery = ProfilePostQuery(page: 1, size: 10)
        let parameters: ProfilePostDefaultValue = ProfilePostDefaultValue(date: "", memberId: currentState.memberId, sort: "DESC")
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.setLoading(true)),
                // 프로필 조회에서 x
                // 제일 쉬운방법 reactor init 에서 내 맴버 아이디 == 상대방 멤버 아이디 비겨 true false 값 state 주입
                // reactor.state.map 해서 편집 hidden, enabled 처리 
                profileUseCase.executeProfileMemberItems(memberId: currentState.memberId)
                    .asObservable()
                    .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
                            .just(.setProfileMemberItems(entity))
                    },
                
                profileUseCase.executeProfilePostItems(query: query, parameters: parameters)
                    .asObservable()
                    .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
                        var sectionItem: [ProfileFeedSectionItem] = []
                        if entity.results.isEmpty {
                            sectionItem.append(.feedCateogryEmptyItem(ProfileFeedEmptyCellReactor(descrption: "아직 업로드한 사진이 없어요", resource: "EmptyCaseGraphicEmoji")))
                        } else {
                            entity.results.forEach {
                                sectionItem.append(.feedCategoryItem(ProfileFeedCellReactor(imageURL: $0.imageUrl, emojiCount: $0.emojiCount, date:  $0.createdAt.toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ").relativeFormatter())))
                            }
                        }
                        return .concat(
                            .just(.setProfilePostItems(entity)),
                            .just(.setFeedCategroySection(sectionItem)),
                            .just(.setLoading(false))
                        )

                    }
            )
            
        case .viewWillAppear:
            return .concat(
                profileUseCase.executeProfileMemberItems(memberId: currentState.memberId)
                    .asObservable()
                    .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
                            .concat(
                                .just(.setProfileMemberItems(entity)),
                                .just(.setLoading(false))
                            
                            )
                    }
            )
            
            
        case let .didSelectPHAssetsImage(fileData):
            let profileImage: String = "\(fileData.hashValue).jpg"
            let profileImageEditParameter: CameraDisplayImageParameters = CameraDisplayImageParameters(imageName: profileImage)
            return .concat(
                .just(.setLoading(true)),
                profileUseCase.executeProfileImageURLCreate(parameter: profileImageEditParameter)
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .asObservable()
                    .flatMap { owner, entity -> Observable<ProfileViewReactor.Mutation> in
                        guard let profilePresingedURL = entity?.imageURL else { return .empty() }
                        return owner.profileUseCase.executeProfileImageToPresingedUpload(to: profilePresingedURL, data: fileData)
                            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .asObservable()
                            .flatMap { isSuccess -> Observable<ProfileViewReactor.Mutation> in
                                let originalPath = owner.configureProfileOriginalS3URL(url: profilePresingedURL)
                                let profileEditParameter: ProfileImageEditParameter = ProfileImageEditParameter(profileImageUrl: originalPath)
                                if isSuccess {
                                    return owner.profileUseCase.executeReloadProfileImage(memberId: self.currentState.memberId, parameter: profileEditParameter)
                                        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                        .asObservable()
                                        .flatMap { memberEntity -> Observable<ProfileViewReactor.Mutation> in
                                            return .concat(
                                                .just(.setProfilePresingedURL(entity)),
                                                .just(.setPresignedS3Upload(isSuccess)),
                                                .just(.setProfileMemberItems(memberEntity)),
                                                .just(.setLoading(false))
                                            
                                            )
                                        }
                                    
                                } else {
                                    return .empty()
                                }
                                
                            }
                        
                        
                    }
            )
            
        case let .fetchMorePostItems(isPagination):
            query.page += 1
            guard self.currentState.profilePostEntity?.hasNext == true && isPagination else { return .empty() }

            return profileUseCase.executeProfilePostItems(query: query, parameters: parameters)
                .asObservable()
                .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
                    guard let originalItems = self.currentState.profilePostEntity?.results else { return .empty() }
                    var paginationItems: [ProfilePostResultResponse] = originalItems
                    
                    var sectionItem: [ProfileFeedSectionItem] = []
                    paginationItems.append(contentsOf: entity.results)
                   
                    paginationItems.forEach {
                        sectionItem.append(.feedCategoryItem(ProfileFeedCellReactor(imageURL: $0.imageUrl, emojiCount: $0.emojiCount, date: $0.createdAt.toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ").relativeFormatter())))
                    }
                    
                    return .concat(
                        .just(.setLoading(true)),
                        .just(.setFeedCategroySection(sectionItem)),
                        .just(.setLoading(false))
                    )
                }
        case let .didTapInitProfile(defualtData):
            //TODO: 유저 디폴트 이미지
//            guard let profileImage = UserDefaults.standard.profileImage else { return .empty() }
            
            let initProfileImage: String = "\(defualtData.hashValue).jpg"
            let profileImageEditParameter: CameraDisplayImageParameters = CameraDisplayImageParameters(imageName: initProfileImage)
            return .concat(
                .just(.setLoading(true)),
                profileUseCase.executeProfileImageURLCreate(parameter: profileImageEditParameter)
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .asObservable()
                    .flatMap { owner, entity -> Observable<ProfileViewReactor.Mutation> in
                        guard let profilePresingedURL = entity?.imageURL else { return .empty() }
                        return owner.profileUseCase
                            .executeProfileImageToPresingedUpload(to: profilePresingedURL, data: defualtData)
                            .subscribe(on:  ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .asObservable()
                            .flatMap { isSuccess -> Observable<ProfileViewReactor.Mutation> in
                                let originalPath = owner.configureProfileOriginalS3URL(url: profilePresingedURL)
                                let profileEditParmater: ProfileImageEditParameter = ProfileImageEditParameter(profileImageUrl: originalPath)
                                if isSuccess {
                                    return owner.profileUseCase
                                        .executeReloadProfileImage(memberId: owner.currentState.memberId, parameter: profileEditParmater)
                                        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                                        .asObservable()
                                        .flatMap { memberEntity -> Observable<ProfileViewReactor.Mutation> in
                                            return .concat(
                                                .just(.setProfilePresingedURL(entity)),
                                                .just(.setPresignedS3Upload(isSuccess)),
                                                .just(.setProfileMemberItems(memberEntity)),
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
        case let .setFeedCategroySection(section):
            let sectionIndex = getSection(.feedCategory([]))
            newState.feedSection[sectionIndex] = .feedCategory(section)
            
        case let .setProfilePostItems(entity):
            newState.profilePostEntity = entity
            
        case let .setProfileMemberItems(entity):
            newState.profileMemberEntity = entity
            
        case let .setProfilePresingedURL(entity):
            newState.profilePresingedURLEntity = entity
            
        case let .setPresignedS3Upload(isProfileUpload):
            newState.isProfileUpload = isProfileUpload
        }
        
        return newState
    }
    
}


extension ProfileViewReactor {
 
    func getSection(_ section: ProfileFeedSectionModel) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.feedSection.count where self.currentState.feedSection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
    
    func configureProfileOriginalS3URL(url: String) -> String {
        guard let range = url.range(of: #"[^&?]+"#, options: .regularExpression) else { return "" }
        return String(url[range])
    }
    
}
