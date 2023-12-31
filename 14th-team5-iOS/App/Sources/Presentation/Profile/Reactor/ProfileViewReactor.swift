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
    
    public enum Action {
        case viewDidLoad
        case viewWillAppear
        case fetchMorePostItems(Bool)
        case didSelectPHAssetsImage(Data)
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
        @Pulse var feedSection: [ProfileFeedSectionModel]
        @Pulse var profileMemberEntity: ProfileMemberResponse?
        @Pulse var profilePostEntity: ProfilePostResponse?
        @Pulse var isProfileUpload: Bool
        @Pulse var profilePresingedURLEntity: CameraDisplayImageResponse?
    }
    
    init(profileUseCase: ProfileViewUsecaseProtocol) {
        self.profileUseCase = profileUseCase
        self.initialState = State(
            isLoading: false,
            feedSection: [.feedCategory([])],
            profileMemberEntity: nil,
            isProfileUpload: false,
            profilePresingedURLEntity: nil
        )
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        //TODO: Keychain, UserDefaults 추가
        var query: ProfilePostQuery = ProfilePostQuery(page: 1, size: 10)
        let parameters: ProfilePostDefaultValue = ProfilePostDefaultValue(date: "", memberId: "01HJBNXAV0TYQ1KESWER45A2QP", sort: "DESC")
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.setLoading(true)),
                profileUseCase.executeProfileMemberItems()
                    .asObservable()
                    .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
                            .just(.setProfileMemberItems(entity))
                    },
                
                profileUseCase.executeProfilePostItems(query: query, parameters: parameters)
                    .asObservable()
                    .flatMap { entity -> Observable<ProfileViewReactor.Mutation> in
                        var sectionItem: [ProfileFeedSectionItem] = []
                        entity.results.forEach {
                            sectionItem.append(.feedCategoryItem(ProfileFeedCellReactor(imageURL: $0.imageUrl, title: $0.content, date: DateFormatter.yyyyMMdd.string(from: $0.createdAt))))
                            
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
                profileUseCase.executeProfileMemberItems()
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
                                    return owner.profileUseCase.executeReloadProfileImage(memberId: "01HJBNXAV0TYQ1KESWER45A2QP", parameter: profileEditParameter)
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
                        sectionItem.append(.feedCategoryItem(ProfileFeedCellReactor(imageURL: $0.imageUrl, emojiCount: $0.emojiCount, date: DateFormatter.yyyyMMdd.string(from: $0.createdAt))))
                    }
                    
                    return .concat(
                        .just(.setLoading(true)),
                        .just(.setFeedCategroySection(sectionItem)),
                        .just(.setLoading(false))
                    )
                }
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
