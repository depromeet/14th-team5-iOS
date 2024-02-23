//
//  UserDefaultsRepositoryProtocol.swift
//  Domain
//
//  Created by 마경미 on 23.02.24.
//

import Foundation

import RxSwift

public protocol UserDefaultsRepositoryProtocol {
    func removeUserDefaultsWhenSignOut()
}
