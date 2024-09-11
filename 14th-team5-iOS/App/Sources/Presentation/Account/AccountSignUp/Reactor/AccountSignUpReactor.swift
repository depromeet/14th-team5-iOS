//
//  AccountSignUpReactor.swift
//  App
//
//  Created by geonhui Yu on 12/8/23.
//

import Core
import Data
import Domain
import Foundation

import ReactorKit

fileprivate typealias _Str = AccountSignUpStrings
public final class AccountSignUpReactor: Reactor {
    public var initialState: State
    private var accountRepository: AccountImpl
    private let memberId: String
    private let profileType: AccountLoaction
    
    public enum Action {
        case setNickname(String)
        case didTapNicknameNextButton
        case didTapNickNameButton(String)
        
        case setYear(Int?)
        case setMonth(Int?)
        case setDay(Int?)
        case didTapDateNextButton
        
        case didTapCompletehButton
        case profilePresignedURL(String, Data)
        case didTapPHAssetsImage(Data)
    }
    
    public enum Mutation {
        case setNickname(String)
        case didTapNicknameNextButton
        
        case setYearValue(Int?)
        case setMonthValue(Int?)
        case setDayValue(Int?)
        case didTapDateNextButton
        case setEditNickName(AccountNickNameEditResponse?)
        
        case setprofilePresignedURL(String)
        case setprofileImage(Data)
        case didTapCompletehButton(AccessTokenResponse?)
        case setPHAssetsImage(Data)
    }
    
    public struct State {
        var nickname: String = ""
        var isValidNickname: Bool = false
        var isValidNicknameButton: Bool = false
        @Pulse var nicknameButtonTappedFinish: Bool = false
        
        var memberId: String
        var profileNickNameEditEntity: AccountNickNameEditResponse?
        var year: Int?
        var isValidYear: Bool = false
        var month: Int = 0
        var isValidMonth: Bool = false
        var day: Int = 0
        var isValidDay: Bool = false
        var isValidDateButton: Bool = false
        @Pulse var dateButtonTappedFinish: Bool = false
        var profileType: AccountLoaction = .account
        
        var profilePresignedURL: String = ""
        var profileImage: Data? = nil
        var didTapCompletehButtonFinish: AccessTokenResponse? = nil
    }
    
    init(
        accountRepository: AccountRepository,
        memberId: String = "",
        profileType: AccountLoaction = .account
    ) {
        self.accountRepository = accountRepository
        self.memberId = memberId
        self.profileType = profileType
        self.initialState = State(memberId: memberId, profileType: self.profileType)
    }
}

extension AccountSignUpReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
            // MARK: Nickname
        case .setNickname(let nickname):
            return Observable.just(Mutation.setNickname(nickname))
        case .didTapNicknameNextButton:
            return Observable.just(Mutation.didTapNicknameNextButton)
            
            // MARK: Date
        case .setYear(let year):
            return Observable.just(Mutation.setYearValue(year))
        case .setMonth(let month):
            return Observable.just(Mutation.setMonthValue(month))
        case .setDay(let day):
            return Observable.just(Mutation.setDayValue(day))
        case .didTapDateNextButton:
            return Observable.just(Mutation.didTapDateNextButton)
            
            // MARK: Profile
        case let .profilePresignedURL(presignedURL, originImage):
            let originProfilePath = configureAccountOriginalS3URL(url: presignedURL)
            return .concat(
                .just(.setprofilePresignedURL(originProfilePath)),
                .just(.setprofileImage(originImage))
            )
        case let .didTapNickNameButton(nickName):
            let parameters: AccountNickNameEditParameter = AccountNickNameEditParameter(name: nickName)
            return accountRepository.executeNicknameUpdate(memberId: currentState.memberId, parameter: parameters)
                .asObservable()
                .flatMap { entity -> Observable<AccountSignUpReactor.Mutation> in
                        .just(.setEditNickName(entity))
                }
            
        case .didTapCompletehButton:
            let date = getDateToString(year: currentState.year!, month: currentState.month, day: currentState.day)
            
            if self.currentState.profilePresignedURL.isEmpty {
                return accountRepository.signUp(name: currentState.nickname, date: date, photoURL: nil).flatMap { tokenEntity -> Observable<Mutation> in
                    return Observable.just(Mutation.didTapCompletehButton(tokenEntity))
                }
            } else {
                return accountRepository.signUp(name: currentState.nickname, date: date, photoURL: currentState.profilePresignedURL).flatMap { tokenEntity -> Observable<Mutation> in
                    return Observable.just(Mutation.didTapCompletehButton(tokenEntity))
                }
            }
        case let .didTapPHAssetsImage(profileImage):
            let originalImage: String = "\(profileImage.hashValue).jpg"
            let profileImageEditParameter: CameraDisplayImageParameters = CameraDisplayImageParameters(imageName: originalImage)
            
            return .concat(
                accountRepository.executePresignedImageURLCreate(parameter: profileImageEditParameter)
                    .withUnretained(self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                    .asObservable()
                    .flatMap { owner, entity -> Observable<AccountSignUpReactor.Mutation> in
                        guard let accountPresignedURL = entity?.imageURL else { return .empty() }
                        return owner.accountRepository.executeProfileImageUpload(to: accountPresignedURL, data: profileImage)
                            .asObservable()
                            .flatMap { isSuccess -> Observable<AccountSignUpReactor.Mutation> in
                                let originalPath = owner.configureAccountOriginalS3URL(url: accountPresignedURL)
                                
                                if isSuccess {
                                   return  .concat(
                                    .just(.setprofilePresignedURL(originalPath)),
                                    .just(.setprofileImage(profileImage))
                                )
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
        case .setNickname(let nickname):
            newState.nickname = nickname
            newState.isValidNickname = nickname.count <= 10
            newState.isValidNicknameButton = nickname.count >= 1
        case .didTapNicknameNextButton:
            newState.nicknameButtonTappedFinish = true
        case .setYearValue(let year):
            
            if let year = year {
                newState.year = year
                newState.isValidYear = year < 2023
            } else {
                newState.isValidDay = false
            }
           
        case .setMonthValue(let month):
            if let month = month {
                newState.month = month
                newState.isValidMonth = month < 13
            } else {
                newState.isValidMonth = false
            }
        case .setDayValue(let day):
            if let day = day {
                newState.day = day
                newState.isValidDay = day < 31
            } else {
                newState.isValidDay = false
            }
        case .didTapDateNextButton:
            newState.dateButtonTappedFinish = true
        case .setprofilePresignedURL(let url):
            newState.profilePresignedURL = url
        case let .setprofileImage(profileImage):
            newState.profileImage = profileImage
        case .didTapCompletehButton(let token):
            if let token = token {
                newState.didTapCompletehButtonFinish = token
            }
        case let .setEditNickName(entity):
            newState.profileNickNameEditEntity = entity
        case let .setPHAssetsImage(profileImage):
            newState.profileImage = profileImage
        }
        
        newState.isValidDateButton = newState.isValidYear && newState.isValidMonth && newState.isValidDay
        return newState
    }
}

extension AccountSignUpReactor {
    func getDateToString(year: Int, month: Int, day: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        let date = Calendar.current.date(from: components) ?? Date()
        return dateFormatter.string(from: date)
    }
    
    func configureAccountOriginalS3URL(url: String) -> String {
        guard let range = url.range(of: #"[^&?]+"#, options: .regularExpression) else { return "" }
        return String(url[range])
    }
}


