//
//  WidgetRepositoryProtocol.swift
//  Domain
//
//  Created by 마경미 on 05.06.24.
//

import Foundation

public protocol WidgetRepositoryProtocol {
    func fetchRecentFamilyPost(completion: @escaping (Result<WidgetPostEntity, Error>) -> Void)
}
