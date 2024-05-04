//
//  CalendarAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Core
import Domain
import Foundation

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

// MARK: - Extensions
extension CalendarAPIWorker {
    
    @available(*, deprecated)
    private func fetchCalendarResponse(spec: APISpec, headers: [APIHeader]?) -> Single<ArrayResponseCalendarEntity?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("CalendarResponse Fetch Result: \(str)")
                }
            }
            .map(ArrayResponseCalendarResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    @available(*, deprecated)
    public func fetchCalendarResponse(yearMonth: String) -> Single<ArrayResponseCalendarEntity?> {
        let spec = CalendarAPIs.calendarResponse(yearMonth).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchCalendarResponse(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func fetchStatisticsSummary(spec: APISpec, headers: [APIHeader]?) -> Single<FamilyMonthlyStatisticsEntity?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("StatisticsSummary Fetch Result: \(str)")
                }
            }
            .map(FamilyMonthlyStatisticsResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchMonthlyCalendar(yearMonth: String) -> Single<ArrayResponseMonthlyCalendarEntity?> {
        let spec = CalendarAPIs.monthlyCalendar(yearMonth).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchMonthlyCalendar(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    
    private func fetchMonthlyCalendar(spec: APISpec, headers: [APIHeader]?) -> Single<ArrayResponseMonthlyCalendarEntity?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("MonthlyCalendar Fetch Result: \(str)")
                }
            }
            .map(ArrayResponseMonthlyCalendarResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchDailyCalendar(yearMonth: String) -> Single<ArrayResponseDailyCalendarEntity?> {
        let spec = CalendarAPIs.monthlyCalendar(yearMonth).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchDailyCalendar(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    
    private func fetchDailyCalendar(spec: APISpec, headers: [APIHeader]?) -> Single<ArrayResponseDailyCalendarEntity?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("DailyCalendar Fetch Result: \(str)")
                }
            }
            .map(ArrayResponseDailyCalendarResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchStatisticsSummary(yearMonth: String) -> Single<FamilyMonthlyStatisticsEntity?> {
        let spec = CalendarAPIs.statisticsSummary(yearMonth).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchStatisticsSummary(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func fetchCalendarBanner(spec: APISpec, headers: [APIHeader]?) -> Single<BannerEntity?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Banner Fetch Result: \(str)")
                }
            }
            .map(BannerResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchCalendarBanner(yearMonth: String) -> Single<BannerEntity?> {
        let spec = CalendarAPIs.calendarBenner(yearMonth).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchCalendarBanner(spec: spec, headers: $0.1) }
            .asSingle()
    }
}
