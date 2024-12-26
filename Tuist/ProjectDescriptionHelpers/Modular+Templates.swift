//
//  Modular+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

import ProjectDescription


public struct ModularFactory {
    var name: ModuleLayer.RawValue
    var destinations: Destinations
    var products: ProductsType
    var platform: Platform
    var dependencies: [TargetDependency]
    var bundleId: String
    var deploymentTargets: DeploymentTargets?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var settings: Settings? = .settings(
        base: [
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "OTHER_LDFLAGS": "$(inherited) -ObjC"
        ]
    )
    var entitlements: Entitlements?
    
    
    public init(
        name: ModuleLayer.RawValue = "",
        destinations: Destinations = .iOS,
        products: ProductsType = .framework(.static),
        platform: Platform = .iOS,
        dependencies: [TargetDependency] = [],
        bundleId: String = "",
        deploymentTargets: DeploymentTargets? = .defualt,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = .default,
        resources: ResourceFileElements? = .default,
        settings: Settings? = nil,
        entitlements: Entitlements? = nil
    ) {
        self.name = name
        self.destinations = destinations
        self.products = products
        self.platform = platform
        self.dependencies = dependencies
        self.bundleId = bundleId
        self.deploymentTargets = deploymentTargets
        self.infoPlist = infoPlist
        self.sources = sources
        self.resources = resources
        self.settings = settings
        self.entitlements = entitlements
    }
}


extension Target {
    public static func makeModular(extenions layer: ExtensionsLayer, factory: ModularFactory) -> Target {
        switch layer {
        case .Widget:
            return .target(
                name: layer.rawValue + "Extension",
                destinations: factory.destinations,
                product: factory.products.isExtensions ? .appExtension : .app,
                bundleId: factory.bundleId.lowercased(),
                deploymentTargets: factory.deploymentTargets,
                infoPlist: factory.infoPlist,
                sources: factory.products.isExtensions ? .widgetExtensionSources : .default,
                resources: factory.products.isExtensions ? .widgetExtensionResources : .default,
                entitlements: factory.entitlements,
                dependencies: factory.dependencies,
                settings: factory.settings
            )
        }
    }
    
    public static func makeModular(layer: ModuleLayer, factory: ModularFactory) -> Target {
        
        switch layer {
        case .App:
            return .target(
                name: layer.rawValue,
                destinations: [.iPhone],
                product: factory.products.isApp ? .app : .staticFramework,
                bundleId: factory.bundleId.lowercased(),
                deploymentTargets: factory.deploymentTargets,
                infoPlist: factory.infoPlist,
                sources: factory.sources,
                resources: factory.resources,
                entitlements: factory.entitlements,
                scripts: [.firebaseCrashlytics],
                dependencies: factory.dependencies,
                settings: factory.settings
            )
        case .Data:
            return .target(
                name: layer.rawValue,
                destinations: .iOS,
                product: factory.products.isLibrary ? .staticFramework : .framework,
                bundleId: "com.\(layer.rawValue).project".lowercased(),
                deploymentTargets: factory.deploymentTargets,
                infoPlist: factory.infoPlist,
                sources: factory.sources,
                resources: factory.resources,
                entitlements: factory.entitlements,
                dependencies: factory.dependencies,
                settings: factory.settings
            )
        case .Domain:
            
            return .target(
                name: layer.rawValue,
                destinations: .iOS,
                product: factory.products.isFramework ? .staticFramework : .framework,
                bundleId: "com.\(layer.rawValue).project".lowercased(),
                deploymentTargets: factory.deploymentTargets,
                infoPlist: factory.infoPlist,
                sources: factory.sources,
                resources: factory.resources,
                entitlements: factory.entitlements,
                dependencies: factory.dependencies,
                settings: factory.settings
            )
        case .Util:
            return .target(
                name: layer.rawValue,
                destinations: .iOS,
                product: factory.products.isFramework ? .staticFramework : .framework,
                bundleId: "com.\(layer.rawValue).project".lowercased(),
                deploymentTargets: factory.deploymentTargets,
                infoPlist: factory.infoPlist,
                sources: factory.sources,
                resources: factory.resources,
                entitlements: factory.entitlements,
                dependencies: factory.dependencies,
                settings: factory.settings
            )
            
        case .Core:
            return .target(
                name: layer.rawValue,
                destinations: .iOS,
                product: factory.products.isLibrary ? .framework : .staticFramework,
                bundleId: "com.\(layer.rawValue).project".lowercased(),
                deploymentTargets: factory.deploymentTargets,
                infoPlist: factory.infoPlist,
                sources: factory.sources,
                resources: factory.resources,
                entitlements: factory.entitlements,
                dependencies: factory.dependencies,
                settings: factory.settings
            )
        case .DesignSystem:
            
            return .target(
                name: layer.rawValue,
                destinations: .iOS,
                product: factory.products.isFramework ? .staticFramework : .framework,
                bundleId: "com.\(layer.rawValue).project".lowercased(),
                deploymentTargets: factory.deploymentTargets,
                infoPlist: factory.infoPlist,
                sources: factory.sources,
                resources: factory.resources,
                entitlements: factory.entitlements,
                dependencies: factory.dependencies,
                settings: factory.settings
            )
        }
        
    }
    
}
