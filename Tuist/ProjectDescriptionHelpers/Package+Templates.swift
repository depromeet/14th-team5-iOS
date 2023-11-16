//
//  Package+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 11/16/23.
//

import ProjectDescription
import ProjectDescriptionHelpers


extension Package {
    private static func remote(repo: String, version: Version) -> Package {
        return Package.remote(url: "https://github.com/\(repo).git", requirement: .exact(version))
    }
    
    
   public static let reactorKit = Package.remote(repo: "ReactorKit/ReactorKit", version: "3.2.0")
   public static let rxSwift = Package.remote(repo: "ReactiveX/RxSwift", version: "6.6.0")
   public static let alamofire = Package.remote(repo: "Alamofire/Alamofire", version: "5.8.1")
    
}

