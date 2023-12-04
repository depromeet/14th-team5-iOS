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
            infoPlist: .extendingDefault(with: [
                "CFBundleVersion": .string("1"),
                "CFBuildVersion": .string("0"),
                "UILaunchStoryboardName": .string("Launch Screen"),
                "UISupportedInterfaceOrientations": .array([.string("UIInterfaceOrientationPortrait")]),
                "UIUserInterfaceStyle": .string("Light"),
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
                ])
            ])
        )
    ),
    .makeModular(extenions: .Widget, factory: .init(
        products: .appExtension,
        infoPlist: .extendingDefault(with: [
            "CFBundleDisplayName": .string("$(PRODUCT_NAME)"),
            "NSExtension" : .dictionary([
                "NSExtensionMainStoryboard": "MainInterface",
                "NSExtensionPointIdentifier": .string("com.apple.widgetkit-extension")
            ])
        ])
    )
)
]


private let app = Project.makeApp(name: ModuleLayer.App.rawValue, target: targets)
