//
//  WidgetAPIWorker.swift
//  Data
//
//  Created by 마경미 on 05.06.24.
//

import RxSwift

typealias WidgetAPIWorker = WidgetAPIs.Worker
extension WidgetAPIWorker {
    /// 가장 최근에 올라온 가족의 게시글 하나를 조회하는 Method입니다.
    /// HTTP Method: GET
    /// - Returns: GetRecentPostsResponseDTO
    func fetchRecentFamilyPost() -> Observable<GetRecentPostsResponseDTO> {
        let spec = WidgetAPIs.fetchRecentFamilyPost.spec

        return request(spec)
    }
}
