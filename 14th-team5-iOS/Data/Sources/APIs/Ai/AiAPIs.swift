//
//  AiAPIs.swift
//  Data
//
//  Created by 김도현 on 9/25/25.
//

import Core
import Domain
import Foundation


enum AiAPIs: BBAPI {
    /// AI 이미지 변환 API
    case createAIImageGenerate
    
    var spec: Spec {
        return Spec(method: .post, path: "/ai-images/convert")
    }
    
    public final class Worker: BBRxAPIWorker {
        public init() { super.init() }
    }

}
