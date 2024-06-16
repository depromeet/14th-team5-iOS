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

public typealias CalendarAPIWorker = CalendarAPIs.Worker
extension CalendarAPIs {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "CalendarAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "CalendarAPIWorker"
        }
    }
}

// MARK: - Extensions

extension CalendarAPIWorker {
    
    
    // MARK: - Fetch Calendar
    
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
    
    
    
    // MARK: - Fetch Statistics Summary
    
    public func fetchStatisticsSummary(yearMonth: String) -> Single<FamilyMonthlyStatisticsEntity?> {
        let spec = CalendarAPIs.fetchStatisticsSummary(yearMonth).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchStatisticsSummary(spec: spec, headers: $0.1) }
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
    
    
    
    // MARK: - Fetch Monthly Calendar
    
    public func fetchMonthlyCalendar(yearMonth: String) -> Single<ArrayResponseMonthlyCalendarEntity?> {
        let spec = CalendarAPIs.fetchMonthlyCalendar(yearMonth).spec
        
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
    
    
    
    // MARK: - Fetch Daily Calendar
    
    public func fetchDailyCalendar(yearMonthDay: String) -> Single<ArrayResponseDailyCalendarEntity?> {
        let spec = CalendarAPIs.fetchDailyCalendar(yearMonthDay).spec
        
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
    
    
    
    
    // MARK: - Fetch Banner
    
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
        let spec = CalendarAPIs.fetchBanner(yearMonth).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchCalendarBanner(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    
}
