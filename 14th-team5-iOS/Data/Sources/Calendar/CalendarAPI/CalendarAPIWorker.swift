//
//  CalendarAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Foundation

import Alamofire
import Domain
import RxSwift

typealias CalendarAPIWorker = CalendarAPIs.Worker
extension CalendarAPIs {
    final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "CalendarAPIQueue", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "CalendarAPIWorker"
        }
    }
}

extension CalendarAPIWorker {
    func fetchCalendarInfo(yearMonth: String) -> Single<ArrayResponseCalendarResponse?> {
        let accessToken: String = "eyJyZWdEYXRlIjoxNzA0Mjg4NTg5NzMxLCJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJ1c2VySWQiOiIwMUhKQk5XWkdOUDFLSk5NS1dWWkowMzlIWSIsImV4cCI6MTcwNDM3NDk4OX0.Yp--MmXHsTqCJnG-dc43zUMD8HOtn6M0ihdmOce_nrc" // TODO: - 접근 토큰 구하기
        let spec = CalendarAPIs.calendarInfo(yearMonth: yearMonth).spec
        let headers: [BibbiHeader] = [.acceptJson, .xAuthToken(accessToken)]
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("MonthlyCalendar Fetch Result: \(str)")
                }
            }
            .map(ArrayResponseCalendarResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
}
