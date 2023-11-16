//
//  Modular+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

import ProjectDescription


public struct ModularFactory {
    var name: ModuleLayer.RawValue
    var platform: Platform
    var products: ProductsType
    var dependencies: [TargetDependency]
    var bundleId: String
    var deploymentTarget: DeploymentTarget?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var settings: Settings?
    
    
    public init(
        name: ModuleLayer.RawValue = "",
        platform: Platform = .iOS,
        products: ProductsType = .framework(.static),
        dependencies: [TargetDependency] = [],
        bundleId: String = "",
        deploymentTarget: DeploymentTarget? = .defualt,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = .default,
        resources: ResourceFileElements? = .default,
        settings: Settings? = nil
    ) {
        self.name = name
        self.platform = platform
        self.products = products
        self.dependencies = dependencies
        self.bundleId = bundleId
        self.deploymentTarget = deploymentTarget
        self.infoPlist = infoPlist
        self.sources = sources
        self.resources = resources
        self.settings = settings
    }
}


extension Target {
    public static func makeModular(layer: ModuleLayer, factory: ModularFactory) -> Target {
        
        switch layer {
        case .App:
            return Target(
                name: layer.rawValue,
                platform: factory.platform,
                product: factory.products.isApp ? .app : .staticLibrary,
                bundleId: "com.\(layer.rawValue).project".lowercased(),
                deploymentTarget: factory.deploymentTarget,
                infoPlist: factory.infoPlist,
                sources: factory.sources,
                resources: factory.resources,
                dependencies: factory.dependencies,
                settings: factory.settings
            )
        case .Data:
            print("MAKEMODULAR DATA \(layer.rawValue)")
            print("MAKEMODULAR DATA SOURCES PATH: \(factory.sources)")
            return Target(
                name: layer.rawValue,
                platform: factory.platform,
                product: factory.products.isLibrary ? .staticLibrary : .dynamicLibrary,
                bundleId: "com.\(layer.rawValue).project".lowercased(),
                deploymentTarget: factory.deploymentTarget,
                infoPlist: factory.infoPlist,
                sources: factory.sources,
                resources: factory.resources,
                dependencies: factory.dependencies,
                settings: factory.settings
            )
        case .Domain:
            print("MAKEMODULAR Domain \(layer.rawValue)")
            print("MAKEMODULAR Domain SOURCES PATH: \(factory.sources)")
            return Target(
                name: layer.rawValue,
                platform: factory.platform,
                product: factory.products.isFramework ? .staticFramework : .framework,
                bundleId: "com.\(layer.rawValue).project".lowercased(),
                deploymentTarget: factory.deploymentTarget,
                infoPlist: factory.infoPlist,
                sources: factory.sources,
                resources: factory.resources,
                dependencies: factory.dependencies,
                settings: factory.settings
            )
        case .Core:
            print("MAKEMODULAR CORE \(layer.rawValue)")
            print("MAKEMODULAR CORE SOURCES PATH: \(factory.sources)")
            return Target(
                name: layer.rawValue,
                platform: factory.platform,
                product: factory.products.isLibrary ? .staticLibrary : .dynamicLibrary,
                bundleId: "com.\(layer.rawValue).project".lowercased(),
                deploymentTarget: factory.deploymentTarget,
                infoPlist: factory.infoPlist,
                sources: factory.sources,
                resources: factory.resources,
                dependencies: factory.dependencies,
                settings: factory.settings
            )
        case .DesignSystem:
            print("MAKEMODULAR DESIGNESYSTEM \(layer.rawValue)")
            print("MAKEMODULAR DESIGNESYSTEM SOURCES PATH: \(factory.sources)")
            return Target(
                name: layer.rawValue,
                platform: factory.platform,
                product: factory.products.isFramework ? .staticFramework : .framework,
                bundleId: "com.\(layer.rawValue).project".lowercased(),
                deploymentTarget: factory.deploymentTarget,
                infoPlist: factory.infoPlist,
                sources: factory.sources,
                resources: factory.resources,
                dependencies: factory.dependencies,
                settings: factory.settings
            )
        }
        
    }
    
}
