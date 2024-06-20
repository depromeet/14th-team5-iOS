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
        .reactorKit,
        .rxSwift,
        .rxDatasources,
        .snapkit,
        .then,
        .firebase,
        .kakaoSDK,
        .kakaoSDKRx,
        .kingFisher,
        .fsCalendar,
        .mixPanel,
        .lottie,
        .googleUtilities
    ], productTypes: [
        "FSCalendar": .framework,
        "Firebase": .framework,
        "Lottie": .framework
    ],
     baseSettings: .settings(
        configurations: [
            .build(.dev),
            .build(.stg),
            .build(.prd)
        ]
     )
    ),
    platforms: [.iOS]
)
