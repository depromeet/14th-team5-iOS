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
            bundleId: "com.5ing.pippi",
            infoPlist: .extendingDefault(with: [
                "CFBundleVersion": .string("1"),
                "CFBundleDisplayName": .string("pippi"),
                "CFBuildVersion": .string("0"),
                "UILaunchStoryboardName": .string("Launch Screen"),
                "UISupportedInterfaceOrientations": .array([.string("UIInterfaceOrientationPortrait")]),
                "UIUserInterfaceStyle": .string("Light"),
                "NSPhotoLibraryAddUsageDescription" : .string("앨범에 저장하려면 접근 권한이 필요합니다. 접근을 허용하지 않으면 저장 할 수 없으니 '확인'을 선택해 주세요."),
                "NSCameraUsageDescription": .string("사진 및 동영상 촬영을 위한 카메라 사용 권한"),
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
            ])
        )
    ),
    .makeModular(extenions: .Widget, factory: .init(
        products: .appExtension,
        dependencies: ExtensionsLayer.Widget.dependencies,
        bundleId: "com.5ing.pippi.widgetExtenions",
        infoPlist: .extendingDefault(with: [
            "CFBundleDisplayName": .string("pippi"),
            "NSExtension" : .dictionary([
                "NSExtensionPointIdentifier": .string("com.apple.widgetkit-extension")
            ])
        ])
    )
)
]


private let app = Project.makeApp(name: ModuleLayer.App.rawValue, target: targets)
