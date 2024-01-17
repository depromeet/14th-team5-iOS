//
//  PostCommentAPIWorker.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Domain
import Foundation

import RxSwift

typealias PostCommentAPIWorker = PostCommentAPIs.Worker
extension PostCommentAPIs {
    final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "PostCommentAPIWorker", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "PostCommentAPIWorker"
        }
    }
}

extension PostCommentAPIWorker {
    
}
