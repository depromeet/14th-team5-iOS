//
//  WidgetRepository.swift
//  Data
//
//  Created by 마경미 on 05.06.24.
//

import Foundation

import Domain

import RxSwift

public final class WidgetRepository: WidgetRepositoryProtocol {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let widgetAPIWorker: WidgetAPIWorker = WidgetAPIWorker()
    
    public init () { }
    
    public func fetchRecentFamilyPost(
        date: String,
        completion: @escaping (Result<WidgetPostEntity, Error>
        ) -> Void) {
        widgetAPIWorker.fetchRecentFamilyPost(date: date)
            .map { $0.toDomain() }
            .subscribe(
                onNext: { result in
                    completion(.success(result))
                },
                onError: { error in
                    completion(.failure(error))
                }
            )
            .disposed(by: disposeBag)
    }
}
