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
        case updateNickNameProfile(Data)
        case fetchMorePostItems(Bool)
        case didSelectPHAssetsImage(Data)
        case didTapInitProfile
        case didTapSegementControl(BibbiFeedType)
        case didTapProfilePost(IndexPath, [ProfilePostResultResponse])
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setProfilePresingedURL(CameraDisplayImageResponse?)
        case setFeedCategroySection([ProfileFeedSectionItem])
        case setFeedResultItems([ProfilePostResultResponse])
        case setProfileMemberItems(ProfileMemberResponse?)
        case setProfileFeedType(BibbiFeedType)
        case setProfilePostItems(ProfilePostResponse)
        case setProfileData(PostSection.Model, IndexPath)
    }
    
    public struct State {
        var isLoading: Bool
        var memberId: String
        var isUser: Bool
        var feedType: BibbiFeedType
        @Pulse var profileData: PostSection.Model
        @Pulse var selectedIndexPath: IndexPath?
        @Pulse var feedResultItem: [ProfilePostResultResponse]
        @Pulse var feedSection: [ProfileFeedSectionModel]
        @Pulse var profileMemberEntity: ProfileMemberResponse?
        @Pulse var profilePostEntity: ProfilePostResponse?
        @Pulse var profilePresingedURLEntity: CameraDisplayImageResponse?
    }
    
    init(profileUseCase: ProfileViewUsecaseProtocol, provider: GlobalStateProviderProtocol, memberId: String, isUser: Bool) {
        self.profileUseCase = profileUseCase
        self.memberId = memberId
        self.isUser = isUser
        self.initialState = State(
            isLoading: false,
            memberId: memberId,
            isUser: isUser,
            feedType: .survival,
            profileData: PostSection.Model(
                model: 0, items: []
            ),
            selectedIndexPath: nil, 
            feedResultItem: [],
            feedSection: [.feedCategory([])],
            profileMemberEntity: nil,
            profilePresingedURLEntity: nil
        )
        
        self.provider = provider
    }
    
    private var provider: GlobalStateProviderProtocol
    
    public func mutate(action: Action) -> Observable<Mutation> {
        //TODO: Keychain, UserDefaults 추가
        var query: ProfilePostQuery = ProfilePostQuery(page: 1, size: 10)
        let parameters: ProfilePostDefaultValue = ProfilePostDefaultValue(date: "", memberId: currentState.memberId, type: currentState.feedType.rawValue, sort: "DESC")
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.setLoading(false)),
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
                            sectionItem.append(.feedCateogryEmptyItem(ProfileFeedEmptyCellReactor(descrption: "아직 업로드한 사진이 없어요", resource: "profileEmpty")))
                        } else {
                            entity.results.forEach {
                                sectionItem.append(.feedCategoryItem(ProfileFeedCellReactor(imageURL: $0.imageUrl, emojiCount: $0.emojiCount, date:  $0.createdAt.toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ").relativeFormatter(), commentCount: $0.commentCount, content: $0.content.map { "\($0)"})))
                            }
                        }
                        return .concat(
                            .just(.setProfilePostItems(entity)),
                            .just(.setFeedResultItems(entity.results)),
                            .just(.setFeedCategroySection(sectionItem)),
                            .just(.setLoading(true))
                        )
                        
                    }
            )
        case let .updateNickNameProfile(nickNameFileData):
            let nickNameProfileImage: String = "\(nickNameFileData.hashValue).jpg"
            let nickNameImageEditParameter: CameraDisplayImageParameters = CameraDisplayImageParameters(imageName: nickNameProfileImage)
            return .concat(
                .just(.setLoading(false)),
                profileUseCase.executeProfileImageURLCreate(parameter: nickNameImageEditParameter)
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .asObservable()
                    .flatMap { owner, entity -> Observable<ProfileViewReactor.Mutation> in
                        guard let profilePresingedURL = entity?.imageURL else { return .empty() }
                        return owner.profileUseCase.executeProfileImageToPresingedUpload(to: profilePresingedURL, data: nickNameFileData)
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
            return .concat(
                profileUseCase.executeProfileMemberItems(memberId: currentState.memberId)
                    .asObservable()
                    .withUnretained(self)
                    .flatMap { owner ,entity -> Observable<ProfileViewReactor.Mutation> in
                            .concat(
                                .just(.setLoading(false)),
                                .just(.setProfileMemberItems(entity)),
                                .just(.setLoading(true))
                            )
                    }
                
            )
        
        case let .didSelectPHAssetsImage(fileData):
            let profileImage: String = "\(fileData.hashValue).jpg"
            let profileImageEditParameter: CameraDisplayImageParameters = CameraDisplayImageParameters(imageName: profileImage)
            return .concat(
                .just(.setLoading(false)),
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
                        sectionItem.append(.feedCategoryItem(ProfileFeedCellReactor(imageURL: $0.imageUrl, emojiCount: $0.emojiCount, date: $0.createdAt.toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ").relativeFormatter(), commentCount: $0.commentCount, content: $0.content.map { "\($0)"})))
                    }
                    return .concat(
                        .just(.setLoading(false)),
                        .just(.setProfilePostItems(entity)),
                        .just(.setFeedResultItems(paginationItems)),
                        .just(.setFeedCategroySection(sectionItem)),
                        .just(.setLoading(true))
                    )
                }
        case .didTapInitProfile:
            return profileUseCase.executeDeleteProfileImage(memberId: memberId)
                .asObservable()
                .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
                    return .concat(
                        .just(.setLoading(false)),
                        .just(.setProfileMemberItems(entity)),
                        .just(.setLoading(true))
                    )
                    
                }
            
            
        case let .didTapProfilePost(indexPath, postEntity):
            guard let profleEntity = currentState.profileMemberEntity else { return .empty() }
            var postSection: PostSection.Model = .init(model: 0, items: [])
            postEntity.forEach {
                postSection.items.append(
                    .main(
                        PostListData(
                            postId: $0.postId,
                            author: ProfileData(memberId: memberId, profileImageURL: profleEntity.memberImage.absoluteString, name: profleEntity.memberName, dayOfBirth: profleEntity.dayOfBirth),
                            commentCount: Int($0.commentCount) ?? 0,
                            emojiCount: Int($0.emojiCount) ?? 0,
                            imageURL: $0.imageUrl.absoluteString,
                            content: $0.content,
                            time: $0.createdAt
                        )
                    )
                )
            }
            return .just(.setProfileData(postSection, indexPath))
          
          
        case let .didTapSegementControl(feedType):
          let feedQuery: ProfilePostQuery = ProfilePostQuery(page: 1, size: 10)
          let feedParameters: ProfilePostDefaultValue = ProfilePostDefaultValue(date: "", memberId: currentState.memberId, type: feedType.rawValue, sort: "DESC")
          
          return .concat(
            .just(.setLoading(false)),
            .just(.setProfileFeedType(feedType)),
            profileUseCase.executeProfilePostItems(query: feedQuery, parameters: feedParameters)
              .asObservable()
              .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
                var sectionItem: [ProfileFeedSectionItem] = []
                if entity.results.isEmpty {
                  sectionItem.append(.feedCateogryEmptyItem(ProfileFeedEmptyCellReactor(descrption: "아직 업로드한 사진이 없어요", resource: "profileEmpty")))
                } else {
                  entity.results.forEach {
                    sectionItem.append(
                      .feedCategoryItem(
                        ProfileFeedCellReactor(
                          imageURL: $0.imageUrl,
                          emojiCount: $0.emojiCount,
                          date: $0.createdAt.toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ").relativeFormatter(),
                          commentCount: $0.commentCount,
                          content: $0.content.map {"\($0)"}
                        )
                      )
                    )
                  }
                }
                return .concat(
                  .just(.setProfilePostItems(entity)),
                  .just(.setFeedResultItems(entity.results)),
                  .just(.setFeedCategroySection(sectionItem)),
                  .just(.setLoading(true))
                )
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
            provider.profileGlobalState.refreshFamilyMembers()
            newState.profileMemberEntity = entity
            
        case let .setProfilePresingedURL(entity):
            newState.profilePresingedURLEntity = entity
            
        case let .setProfileData(profileData, indexPath):
            newState.profileData = profileData
            newState.selectedIndexPath = indexPath
            
        case let .setFeedResultItems(feedResultItem):
            newState.feedResultItem = feedResultItem
        case let .setProfileFeedType(feedType):
            newState.feedType = feedType
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
