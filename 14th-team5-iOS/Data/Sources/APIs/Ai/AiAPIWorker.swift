//
//  AiAPIWorker.swift
//  Data
//
//  Created by 김도현 on 9/25/25.
//

import Core
import Foundation


import Alamofire
import Domain

typealias AiAPIWorker = AiAPIs.Worker



extension AiAPIWorker {
    
    public func createAiImage(_ binaryData: Data) async throws -> CreateAiImageGenerateResponseDTO  {
        let spec = AiAPIs.createAIImageGenerate.spec
        
        return try await upload(spec, with: binaryData, multipartFormData: [:])
    }
    
}
