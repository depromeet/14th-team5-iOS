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
    
    public let disposeBag: DisposeBag = DisposeBag()
    private let widgetAPIWorker: WidgetAPIWorker = WidgetAPIWorker()
    
    public init () { }
    
    public func fetchRecentFamilyPost(completion: @escaping (Result<Domain.RecentFamilyPostData?, Error>) -> Void) {
        widgetAPIWorker.fetchRecentFamilyPost()
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
