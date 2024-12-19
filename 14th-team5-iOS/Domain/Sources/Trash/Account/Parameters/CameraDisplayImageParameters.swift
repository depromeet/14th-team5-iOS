//
//  CameraDisplayImageParameters.swift
//  Domain
//
//  Created by Kim dohyun on 12/21/23.
//

import Foundation


public struct CameraDisplayImageParameters: Encodable {
    public var imageName: String
    
    public init(imageName: String) {
        self.imageName = imageName
    }
}
