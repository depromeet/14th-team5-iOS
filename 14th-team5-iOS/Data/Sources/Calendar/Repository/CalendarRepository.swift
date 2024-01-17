//
//  CalendarViewRepository.swift
//  Data
//
//  Created by 김건우 on 12/15/23.
//

import Core
import Domain
import Foundation

import RxSwift

public final class CalendarRepository: CalendarRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let calendarApiWorker: CalendarAPIWorker = CalendarAPIWorker()
    
    private let dateOfBirths: [Date] = FamilyUserDefaults.getDateOfBirths()
    
    private var familyId: String = App.Repository.member.familyId.value ?? ""
    private var accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
    
    public init() {
        bind()
    }
    
    private func bind() {
        App.Repository.member.familyId
            .compactMap { $0 }
            .withUnretained(self)
            .bind(onNext: { $0.0.familyId = $0.1 })
            .disposed(by: disposeBag)
        
        App.Repository.token.accessToken
            .compactMap { $0?.accessToken }
            .withUnretained(self)
            .bind(onNext: { $0.0.accessToken = $0.1 })
            .disposed(by: disposeBag)
    }
}

extension CalendarRepository {
    public func checkDateOfBirth(_ date: Date) -> Bool {
        return dateOfBirths.contains(where: { 
            $0.isEqual(
                [.month, .day],
                with: date
            )
        })
    }
    
    public func fetchCalendarInfo(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?> {
        return calendarApiWorker.fetchCalendarInfo(yearMonth, token: accessToken)
            .asObservable()
    }
    
    public func fetchFamilyStatisticsInfo() -> Observable<FamilyMonthlyStatisticsResponse?> {
        return calendarApiWorker.fetchFamilyStatisticsInfo(token: accessToken, familyId: familyId)
            .asObservable()
    }
}
