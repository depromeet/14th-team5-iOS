// swift-tools-version: 5.9
@preconcurrency import PackageDescription
import CompilerPluginSupport

#if TUIST
@preconcurrency import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: ["Macros": .macro],
        baseSettings: .settings(configurations: [
            .debug(name: .configuration("DEV")),
            .release(name: .configuration("PRD"))
        ])
    )
#endif

let package = Package(
    name: "Bibbi",
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.6.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
        .package(url: "https://github.com/devxoul/Then.git", from: "3.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.25.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "5.0.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git", from: "2.22.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk-rx.git", from: "2.22.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.9.1"),
        .package(url: "https://github.com/WenchaoD/FSCalendar.git", from: "2.8.3"),
        .package(url: "https://github.com/mixpanel/mixpanel-swift.git", from: "4.2.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.0"),
        .package(url: "https://github.com/google/GoogleUtilities.git", from: "7.13.2"),
        .package(url: "https://github.com/bibbi-team/bibbi-iOS-package.git", from: "0.1.0")
    ], targets: [
        .target(
            name: "Bibbi",
            dependencies: [
                .product(name: "Macros", package: "bibbi-iOS-package")
            ]
        )
    ]
)
