// swift-tools-version: 5.9
import PackageDescription

#if TUIST
  import ProjectDescription
  import ProjectDescriptionHelpers

  let packageSettings = PackageSettings(
    // Customize the product types for specific package product
    // Default is .staticFramework
    // productTypes: ["Alamofire": .framework,]
    productTypes: [
        "RxSwift": .framework,
        "RxCocoa": .framework,
        "ReactorKit": .framework
    ]
  )
#endif


let package = Package(
  name: "14th-team5-iOS",
  dependencies: [
    .package(url: "https://github.com/ReactorKit/ReactorKit", exact: "3.2.0"),
    .package(url: "https://github.com/ReactiveX/RxSwift", exact: "6.6.0"),
    .package(url: "https://github.com/SnapKit/SnapKit", exact: "5.6.0"),
    .package(url: "https://github.com/devxoul/Then", exact: "3.0.0"),
    .package(url: "https://github.com/firebase/firebase-ios-sdk", exact: "10.24.0"),
    .package(url: "https://github.com/RxSwiftCommunity/RxDataSources", exact: "5.0.0"),
    .package(url: "https://github.com/kakao/kakao-ios-sdk", exact: "2.22.0"),
    .package(url: "https://github.com/kakao/kakao-ios-sdk-rx", exact: "2.22.0"),
    .package(url: "https://github.com/onevcat/Kingfisher", exact: "7.9.1"),
    .package(url: "https://github.com/WenchaoD/FSCalendar", exact: "2.8.3"),
    .package(url: "https://github.com/jrendel/SwiftKeychainWrapper", exact: "4.0.0"),
    .package(url: "https://github.com/mixpanel/mixpanel-swift", exact: "4.2.0"),
    .package(url: "https://github.com/airbnb/lottie-ios", exact: "4.4.0")
  ]
)
