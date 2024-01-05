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
    
    private let accessToken: String = App.Repository.token.accessToken.value ?? "eyJ0eXBlIjoiYWNjZXNzIiwicmVnRGF0ZSI6MTcwNDQ2MTA1NTAyOSwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWQiOiIwMUhKQk5XWkdOUDFLSk5NS1dWWkowMzlIWSIsImV4cCI6MTcwNDU0NzQ1NX0.SBez6V6tZ49sr1T-codoXwwQgdtnBoXWyyE2lgjv840"
    
    public init() { }
    
    public func fetchCalendarInfo(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?> {
        let accessToken = "eyJ0eXBlIjoiYWNjZXNzIiwicmVnRGF0ZSI6MTcwNDQ2MTA1NTAyOSwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWQiOiIwMUhKQk5XWkdOUDFLSk5NS1dWWkowMzlIWSIsImV4cCI6MTcwNDU0NzQ1NX0.SBez6V6tZ49sr1T-codoXwwQgdtnBoXWyyE2lgjv840"
        return calendarApiWorker.fetchCalendarInfo(yearMonth, token: accessToken)
            .asObservable()
    }
}
