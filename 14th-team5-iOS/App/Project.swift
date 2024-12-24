//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let targets: [Target] = [
    .makeModular(
        layer: .App,
        factory: .init(
            products: .app,
            dependencies: ModuleLayer.App.dependencies,
            bundleId: "com.5ing.bibbi",
            infoPlist: .extendingDefault(with: [                
                "CFBundleDisplayName": .string("Bibbi"),
                "CFBundleVersion": .string("1"),
                "CFBuildVersion": .string("0"),
                "CFBundleShortVersionString": .string("1.2.5"),
                "UILaunchStoryboardName": .string("LaunchScreen"),
                "UISupportedInterfaceOrientations": .array([.string("UIInterfaceOrientationPortrait")]),
                "UIUserInterfaceStyle": .string("Dark"),
                "NSPhotoLibraryAddUsageDescription" : .string("프로필 사진, 피드 업로드를 위한 사진 촬영을 위해 Bibbi가 앨범에 접근할 수 있도록 허용해 주세요"),
                "NSCameraUsageDescription": .string("프로필 사진, 피드 업로드를 위한 사진 촬영을 위해 Bibbi가 카메라에 접근할 수 있도록 허용해 주세요"),
                "UIApplicationSceneManifest" : .dictionary([
                    "UIApplicationSupportsMultipleScenes" : .boolean(false),
                    "UISceneConfigurations" : .dictionary([
                        "UIWindowSceneSessionRoleApplication" : .array([
                            .dictionary([
                                "UISceneConfigurationName" : .string("Default Configuration"),
                                "UISceneDelegateClassName" : .string("$(PRODUCT_MODULE_NAME).SceneDelegate")
                            ])
                        ])
                    ])
                ]),
                "LSApplicationQueriesSchemes": .array([.string("kakaokompassauth"), .string("kakaolink")]),
                "CFBundleURLTypes": .array([
                    .dictionary([
                        "CFBundleURLSchemes": .array([.string("$(KAKAO_API_KEY)")]),
                    ]),
                ]),
                "KAKAO_LOGIN_API_KEY": .string("$(KAKAO_LOGIN_API_KEY)"),
                "MIXPANEL_API_KEY": .string("$(MIXPANEL_API_KEY)"),
                "TEAM_ID": .string("$(TEAM_ID)"),
            ]),
            settings: .settings(
                base: [
                    "CODE_SIGN_STYLE": "Manual",
                    "DEVELOPMENT_TEAM": "P9P4WJ623F",
                    "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.5ing.bibbi",
                    "CODE_SIGN_IDENTITY": "Apple Distribution"
                ],
                configurations: [
                    .build(.dev, name: "DEV"),
                    .build(.prd, name: "PRD"),
                    .build(.stg, name: "STG")
                ]),
            entitlements: .file(path: .relativeToRoot("App.entitlements"))
        )
    ),
    .makeModular(extenions: .Widget, factory: .init(
        products: .appExtension,
        dependencies: ExtensionsLayer.Widget.dependencies,
        bundleId: "com.5ing.bibbi.widget",
        infoPlist: .extendingDefault(with: [
            "CFBundleDisplayName": .string("Bibbi"),
            "NSExtension" : .dictionary([
                "NSExtensionPointIdentifier": .string("com.apple.widgetkit-extension")
            ])
        ]),
        settings: .settings(
            base: [
                "CODE_SIGN_STYLE": "Manual",
                "DEVELOPMENT_TEAM": "P9P4WJ623F",
                "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.5ing.bibbi.widget",
                "CODE_SIGN_IDENTITY": "Apple Distribution"
            ],
            configurations: [
                .build(.dev, name: "DEV"),
                .build(.prd, name: "PRD"),
                .build(.stg, name: "STG")
            ]),
        entitlements: .file(path: .relativeToRoot("App.entitlements"))
    )
)
]


private let app = Project.makeApp(name: ModuleLayer.App.rawValue, target: targets)
