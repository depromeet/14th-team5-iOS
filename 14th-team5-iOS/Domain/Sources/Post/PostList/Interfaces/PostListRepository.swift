//
//  PostListRepository.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation
import RxSwift

public protocol PostListRepository {
    func fetchTodayPostList(query: PostListQuery) -> Single<PostListPage?>
}
