//
//  Dependencies.swift
//  Config
//
//  Created by Kim dohyun on 11/16/23.
//

import ProjectDescription
import ProjectDescriptionHelpers


let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies([
        .alamofire,
        .reactorKit,
        .rxSwift,
        .rxDatasources,
        .snapkit,
        .then,
        .firebase,
        .kakaoSDK,
        .kakaoSDKRx,
        .kingFisher,
        .fsCalendar
    ],baseSettings: .settings(
        configurations: [
            .build(.dev),
            .build(.prd)
        ]
    )
    
    ),
    platforms: [.iOS]
)
