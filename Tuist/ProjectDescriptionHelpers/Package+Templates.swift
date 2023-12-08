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
    public static let alamofire = Package.remote(repo: "Alamofire/Alamofire", version: "5.6.1")
    public static let snapkit = Package.remote(repo: "SnapKit/SnapKit", version: "5.6.0")
    public static let then = Package.remote(repo: "devxoul/Then", version: "3.0.0")
    public static let firebase = Package.remote(repo: "firebase/firebase-ios-sdk", version: "10.18.0")
    public static let rxDatasources = Package.remote(repo: "RxSwiftCommunity/RxDataSources", version: "5.0.0")
    public static let kakaoSDK = Package.remote(repo: "kakao/kakao-ios-sdk", version: "2.19.0")
    public static let kakaoSDKRx = Package.remote(repo: "kakao/kakao-ios-sdk-rx", version: "2.19.0")
    public static let kingFisher = Package.remote(repo: "onevcat/Kingfisher", version: "7.9.1")
    public static let fsCalendar = Package.remote(repo: "WenchaoD/FSCalendar", version: "2.7.0")
}
