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
        
        // MARK: - Headers
        private var _headers: Observable<[APIHeader]?> {
            return App.Repository.token.accessToken
                .map {
                    guard let token = $0, let accessToken = token.accessToken, !accessToken.isEmpty else { return [] }
                    return [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken)]
                }
        }
    }
}

// MARK: - Extensions
extension CalendarAPIWorker {
    private func fetchCalendarResponse(spec: APISpec, headers: [APIHeader]?) -> Single<ArrayResponseCalendarResponse?> {
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
    
    public func fetchCalendarResponse(yearMonth: String) -> Single<ArrayResponseCalendarResponse?> {
        let spec = CalendarAPIs.fetchCalendarResponse(yearMonth).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchCalendarResponse(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func fetchStatisticsSummary(spec: APISpec, headers: [APIHeader]?) -> Single<FamilyMonthlyStatisticsResponse?> {
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
    
    public func fetchStatisticsSummary(yearMonth: String) -> Single<FamilyMonthlyStatisticsResponse?> {
        let spec = CalendarAPIs.fetchStatisticsSummary(yearMonth).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchStatisticsSummary(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func fetchCalendarBanner(spec: APISpec, headers: [APIHeader]?) -> Single<BannerResponse?> {
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
    
    public func fetchCalendarBanner(yearMonth: String) -> Single<BannerResponse?> {
        let spec = CalendarAPIs.fetchCalendarBenner(yearMonth).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchCalendarBanner(spec: spec, headers: $0.1) }
            .asSingle()
    }
}
