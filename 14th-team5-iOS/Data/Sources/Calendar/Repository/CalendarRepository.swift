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
    static let accessToken = "eyJyZWdEYXRlIjoxNzAzMzg3NzgwOTU1LCJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJ1c2VySWQiOiIwMUhKQk5XWkdOUDFLSk5NS1dWWkowMzlIWSIsImV4cCI6MTcwMzQ3NDE4MH0.6sx6lYI4_QKwnP-M4Di3cd8hrTah0JlTj64aDyB0VAg"
}

public protocol CalendarImpl {
    var disposeBag: DisposeBag { get }
    
    func fetchMonthlyCalendar(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?>
    func fetchWeekCalendar(_ yearMonth: String, week: Int) -> Observable<ArrayResponseCalendarResponse?>
}

public final class CalendarRepository: CalendarImpl {
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
