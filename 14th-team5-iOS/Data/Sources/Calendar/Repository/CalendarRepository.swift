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
    
    private let familyId: String = App.Repository.member.familyId.value ?? ""
    private let accessToken: String = App.Repository.token.accessToken.value ?? ""
    
    public init() { }
    
    public func fetchCalendarInfo(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?> {
        return calendarApiWorker.fetchCalendarInfo(yearMonth, token: accessToken)
            .asObservable()
    }
    
    public func fetchFamilySummaryInfo() -> Observable<FamilyMonthlyStatisticsResponse?> {
        return calendarApiWorker.fetchFamilySummaryInfo(token: accessToken, familyId: familyId)
            .asObservable()
    }
}
