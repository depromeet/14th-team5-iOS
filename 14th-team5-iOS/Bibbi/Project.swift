//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers

private let skAdNetworkIDs: [String] = [
    "cstr6suwn9.skadnetwork",
    "4fzdc2evr5.skadnetwork",
    "2fnua5tdw4.skadnetwork",
    "ydx93a7ass.skadnetwork",
    "p78axxw29g.skadnetwork",
    "v72qych5uu.skadnetwork",
    "ludvb6z3bs.skadnetwork",
    "cp8zw746q7.skadnetwork",
    "3sh42y64q3.skadnetwork",
    "c6k4g5qg8m.skadnetwork",
    "s39g8k73mm.skadnetwork",
    "3qy4746246.skadnetwork",
    "f38h382jlk.skadnetwork",
    "hs6bdukanm.skadnetwork",
    "mlmmfzh3r3.skadnetwork",
    "v4nxqhlyqp.skadnetwork",
    "wzmmz9fp6w.skadnetwork",
    "su67r6k2v3.skadnetwork",
    "yclnxrl5pm.skadnetwork",
    "t38b2kh725.skadnetwork",
    "7ug5zh24hu.skadnetwork",
    "gta9lk7p23.skadnetwork",
    "vutu7akeur.skadnetwork",
    "y5ghdn5j9k.skadnetwork",
    "v9wttpbfk9.skadnetwork",
    "n38lu8286q.skadnetwork",
    "47vhws6wlr.skadnetwork",
    "kbd757ywx3.skadnetwork",
    "9t245vhmpl.skadnetwork",
    "a2p9lx4jpn.skadnetwork",
    "22mmun2rn5.skadnetwork",
    "44jx6755aq.skadnetwork",
    "k674qkevps.skadnetwork",
    "4468km3ulz.skadnetwork",
    "2u9pt9hc89.skadnetwork",
    "8s468mfl3y.skadnetwork",
    "klf5c3l5u5.skadnetwork",
    "ppxm28t8ap.skadnetwork",
    "kbmxgpxpgc.skadnetwork",
    "uw77j35x4d.skadnetwork",
    "578prtvx9j.skadnetwork",
    "4dzt52r2t5.skadnetwork",
    "tl55sbb4fm.skadnetwork",
    "c3frkrj4fj.skadnetwork",
    "e5fvkxwrpn.skadnetwork",
    "8c4e2ghe7u.skadnetwork",
    "3rd42ekr43.skadnetwork",
    "97r2b46745.skadnetwork",
    "3qcr597p9d.skadnetwork"
  ]


private let targets: [Target] = [
    .makeModular(
        layer: .Bibbi,
        factory: .init(
            products: .bibbi,
            dependencies: ModuleLayer.Bibbi.dependencies,
            bundleId: "com.5ing.bibbi",
            infoPlist: .extendingDefault(with: [
                "SERVICE_NAME": .string("$(SERVICE_NAME)"),
                "ACCESS_GROUP": .string("$(ACCESS_GROUP)"),
                "CFBundleDisplayName": .string("Bibbi"),
                "GADApplicationIdentifier": .string("ca-app-pub-7835112884789455~8255253711"),
                "SKAdNetworkItems": .array(
                      skAdNetworkIDs.map { id in
                        .dictionary([
                          "SKAdNetworkIdentifier": .string(id)
                        ])
                      }
                    ),
                "CFBundleVersion": .string("1"),
                "CFBuildVersion": .string("0"),
                "CFBundleShortVersionString": .string("1.5.0"),
                "UILaunchStoryboardName": .string("LaunchScreen"),
                "UISupportedInterfaceOrientations": .array([.string("UIInterfaceOrientationPortrait")]),
                "UIUserInterfaceStyle": .string("Dark"),
                "NSPhotoLibraryAddUsageDescription" : .string("프로필 사진, 피드 업로드를 위한 사진 촬영을 위해 Bibbi가 앨범에 접근할 수 있도록 허용해 주세요"),
                "NSMicrophoneUsageDescription": .string("음성 댓글을 사용하기 위해 Bibbi가 마이크에 접근할 수 있도록 허용해 주세요"),
                "NSCameraUsageDescription": .string("프로필 사진, 피드 업로드를 위한 사진 촬영을 위해 Bibbi가 카메라에 접근할 수 있도록 허용해 주세요"),
                "NSLocationWhenInUseUsageDescription": .string("위치 검색 시 현재 위치와 가까운 장소를 추천하기 위해 Bibbi가 위치에 접근할 수 있도록 허용해 주세요"),
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
                "KAKAO_LOCAL_REST_API_KEY": .string("$(KAKAO_LOCAL_REST_API_KEY)"),
                "GOOGLE_PLACES_API_KEY": .string("$(GOOGLE_PLACES_API_KEY)"),
                "MIXPANEL_API_KEY": .string("$(MIXPANEL_API_KEY)"),
                "TEAM_ID": .string("$(TEAM_ID)"),
            ]),
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": "$(inherited) -ObjC",
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
            "SERVICE_NAME": .string("$(SERVICE_NAME)"),
            "ACCESS_GROUP": .string("$(ACCESS_GROUP"),
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


private let bibbi = Project.makeApp(name: ModuleLayer.Bibbi.rawValue, target: targets)
