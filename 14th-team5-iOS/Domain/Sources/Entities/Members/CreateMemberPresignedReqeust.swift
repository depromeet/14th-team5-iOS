//
//  CreateMemberPresignedReqeust.swift
//  Domain
//
//  Created by 김도현 on 11/22/24.
//

import Foundation


public struct CreateMemberPresignedReqeust {
    public let imageName: String
    
    public init(imageName: String) {
        self.imageName = imageName
    }
}
