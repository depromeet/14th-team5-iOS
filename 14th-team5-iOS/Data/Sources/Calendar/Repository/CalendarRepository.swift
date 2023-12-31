//
//  CalendarViewRepository.swift
//  Data
//
//  Created by 김건우 on 12/15/23.
//

import Foundation

import Domain
import ReactorKit
import RxCocoa
import RxSwift

// NOTE: - 임시 코드
enum TempStr {
    static let familyId = "familyId"

    static let accessToken = "eyJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QiLCJyZWdEYXRlIjoxNzAzODI0MDI2NTMyfQ.eyJ1c2VySWQiOiIwMUhKQk5XWkdOUDFLSk5NS1dWWkowMzlIWSIsImV4cCI6MTcwMzkxMDQyNn0.9oLLeuhBcTOvz0Eh0NTfD8fk4rD9yDgEogVEzLf6o5k"
}

public final class CalendarRepository: CalendarRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let apiWorker: CalendarAPIWorker = CalendarAPIWorker()
    
    public init() { }
    
    // TODO: - AccessToken 구하는 코드 구현
    public func fetchMonthlyCalendar(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?> {
        return apiWorker.fetchMonthlyCalendar(yearMonth, accessToken: TempStr.accessToken)
            .asObservable()
    }
    
    // TODO: - AccessToken 구하는 코드 구현
    public func fetchWeekCalendar(_ yearMonth: String, week: Int) -> Observable<ArrayResponseCalendarResponse?> {
        return apiWorker.fetchWeeklyCalendar(yearMonth, week: week, accessToken: TempStr.accessToken)
            .asObservable()
    }
}
