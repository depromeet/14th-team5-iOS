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
    // MARK: - Properties
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let calendarApiWorker: CalendarAPIWorker = CalendarAPIWorker()
    
    private var familyId: String = App.Repository.member.familyId.value ?? ""
    private let dateOfBirths: [Date] = FamilyUserDefaults.getDateOfBirths()
    
    // MARK: - Intializer
    public init() {
        bind()
    }
    
    // MARK: - Helpers
    private func bind() {
        App.Repository.member.familyId
            .compactMap { $0 }
            .withUnretained(self)
            .bind(onNext: { $0.0.familyId = $0.1 })
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions
extension CalendarRepository {
    public func checkDateOfBirth(_ date: Date) -> Bool {
        return dateOfBirths.contains(where: { 
            $0.isEqual(
                [.month, .day],
                with: date
            )
        })
    }
    
    public func fetchCalendarResponse(yearMonth: String) -> Observable<ArrayResponseCalendarResponse?> {
        return calendarApiWorker.fetchCalendarResponse(yearMonth: yearMonth)
            .asObservable()
    }
    
    public func fetchStatisticsSummary() -> Observable<FamilyMonthlyStatisticsResponse?> {
        return calendarApiWorker.fetchStatisticsSummary(familyId: familyId)
            .asObservable()
    }
}
