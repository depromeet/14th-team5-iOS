//
//  UserDefaultsRepository.swift
//  Data
//
//  Created by 마경미 on 23.02.24.
//

import Foundation

import Domain

import RxSwift

final class UserDefaultsRepository: UserDefaultsRepositoryProtocol {
    func removeUserDefaults() {
        UserDefaults.standard.clear()
    }
}
