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
        let currentDate = Date()
        guard let createAt = myRepository.fetchFamilyCreateAt(),
              let reviewCount = myRepository.fetchReviewCount(),
              let createDays = Calendar.current.dateComponents([.day], from: createAt, to: Date()).day
        else {
            return .just(false)
        }
        
        let lastReviewDate = myRepository.fetchLastReviewDate() ?? createAt
        let isinitalReviewDate = myRepository.fetchLastReviewDate() == nil
        let isLatestVersion = myRepository.fetchIsLatestVersion()
        
        if isinitalReviewDate {
            myRepository.updateLastReviewDate(createAt)
        }
        
        let daysSinceLastReview = Calendar.current.dateComponents([.day], from: lastReviewDate, to: currentDate).day ?? 0
        if daysSinceLastReview >= 365 {
            myRepository.updateReviewCount(0)
            myRepository.updateLastReviewDate(currentDate)
        }
        
        let isReviewAllowed = reviewCount < 3 && (daysSinceLastReview >= 365 || isinitalReviewDate || createDays >= 30)

        if isReviewAllowed && (isLatestVersion || reviewCount == 0) {
            myRepository.updateReviewCount(reviewCount + 1)
            myRepository.updateLastReviewDate(currentDate)
            return .just(true)
        }
        return .just(false)
    }
}
