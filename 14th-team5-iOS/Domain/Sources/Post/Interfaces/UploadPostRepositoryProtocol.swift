//
//  UploadPostRepositoryProtocol.swift
//  Domain
//
//  Created by 마경미 on 30.03.24.
//

import Foundation

import RxSwift

public protocol UploadPostRepositoryProtocol {
    func checkPostUploadedToday() -> Single<Bool>
}
