//
//  FetchUserCreatedAtInfoUseCase.swift
//  Domain
//
//  Created by 김도현 on 2/19/25.
//

import Foundation

import RxSwift

public protocol FetchUserCreatedAtInfoUseCaseProtocol {
    func execute() -> Observable<Bool>
}


public final class FetchUserCreatedAtInfoUseCase: FetchUserCreatedAtInfoUseCaseProtocol {
    private let myRepository: MyRepositoryProtocol
    
    
    public init(myRepository: MyRepositoryProtocol) {
        self.myRepository = myRepository
    }
    
    public func execute() -> Observable<Bool> {
        let currentDate = Date()
        guard let createdAt = myRepository.fetchFamilyCreatedAt(),
              let reviewCount = myRepository.fetchReviewCount(),
              let createDays = Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day
        else {
            return .just(false)
        }
        
        let lastReviewDate = myRepository.fetchLastReviewDate() ?? createdAt
        let isinitalReviewDate = myRepository.fetchLastReviewDate() == nil
        let isLatestVersion = myRepository.fetchIsLatestVersion()
        
        if isinitalReviewDate {
            myRepository.updateLastReviewDate(createdAt)
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
