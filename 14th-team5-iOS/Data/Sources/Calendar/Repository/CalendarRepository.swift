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

    static let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MiLCJyZWdEYXRlIjoxNzA0MTk2NjA2NjE2fQ.eyJ1c2VySWQiOiIwMUhKQk5XWkdOUDFLSk5NS1dWWkowMzlIWSIsImV4cCI6MTcwNDI4MzAwNn0._q3bFjpqj0_WGnE8GOXTXWzXy-V8YkHGbmEtYbQ89cA"
}

public final class CalendarRepository: CalendarRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let calendarApiWorker: CalendarAPIWorker = CalendarAPIWorker()
    private let postListApiWorker: PostListAPIWorker = PostListAPIWorker()
    
    public init() { }
    
    // TODO: - AccessToken 구하는 코드 구현
    public func fetchMonthlyCalendar(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?> {
        return calendarApiWorker.fetchMonthlyCalendar(yearMonth, accessToken: TempStr.accessToken)
            .asObservable()
    }
    
    // TODO: - AccessToken 구하는 코드 구현
    public func fetchWeeklyCalendar(_ yearMonth: String, week: Int) -> Observable<ArrayResponseCalendarResponse?> {
        return calendarApiWorker.fetchWeeklyCalendar(yearMonth, week: week, accessToken: TempStr.accessToken)
            .asObservable()
    }
    
    // TODO: - 
}
