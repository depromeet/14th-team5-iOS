//
//  FetchUserCreateAtInfoUseCase.swift
//  Domain
//
//  Created by 김도현 on 2/19/25.
//

import Foundation

import RxSwift

public protocol FetchUserCreateAtInfoUseCaseProtocol {
    func execute() -> Observable<Bool>
}


public final class FetchUserCreateAtInfoUseCase: FetchUserCreateAtInfoUseCaseProtocol {
    private let myRepository: MyRepositoryProtocol
    
    
    public init(myRepository: MyRepositoryProtocol) {
        self.myRepository = myRepository
    }
    
    public func execute() -> Observable<Bool> {
        let appVersion = Bundle.main.appVersion
        let currentDate = Date()
        
        guard let createAt = myRepository.fetchFamilyCreateAt(),
              let latestVersion = myRepository.fetchLatestVersion(),
              let reviewCount = myRepository.fetchReviewCount(),
              let lastReviewDate = myRepository.fetchLastReviewDate(),
              let createDays = Calendar.current.dateComponents([.day], from: createAt, to: Date()).day
        else {
            return .just(false)
        }
        
        let daysSinceLastReview = Calendar.current.dateComponents([.day], from: lastReviewDate, to: currentDate).day ?? 0
        if daysSinceLastReview >= 365 {
            myRepository.updateReviewCount(0)
            myRepository.updateLastReviewDate(currentDate)
        }
        
        //FIXME:
        
        let isReviewAllowed = reviewCount < 3 && daysSinceLastReview >= 365
        
        print("😡마지막 리뷰 날짜 : \(daysSinceLastReview)😡")
        print("😎생성 날짜 : \(createDays)😎")
        print("📦리뷰 카운트 : \(reviewCount) 📦")
        print("😓앱 버전 : \(appVersion) 😓")
        print("🥶최신 버전 : \(latestVersion)🥶")
        print("😵‍💫허용 값 : \(isReviewAllowed)😵‍💫")
        
        // 기존 사용자는 updateLastReviewDate 에 값이 없기 떄문에 daysSinceLastReview 값이 0 으로떠서 isReviewAllowed가 false로 뜸
        if ((createDays >= 30 && reviewCount == 0) || (appVersion != latestVersion)) && isReviewAllowed {
            myRepository.updateReviewCount(reviewCount + 1)
            myRepository.updateLastReviewDate(currentDate)
            return .just(true)
        }
        
        return .just(false)
    }
}
