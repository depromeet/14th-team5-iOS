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
    var destionation: Destinations = .iOS
    var dependencies: [TargetDependency]
    var bundleId: String
    var deploymentTarget: DeploymentTargets?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var settings: Settings?
    var entitlements: Entitlements?
    
    
    public init(
        name: ModuleLayer.RawValue = "",
        platform: Platform = .iOS,
        products: ProductsType = .framework(.static),
        dependencies: [TargetDependency] = [],
        bundleId: String = "",
        deploymentTarget: DeploymentTargets? = .defualt,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = .default,
        resources: ResourceFileElements? = .default,
        settings: Settings? = nil,
        entitlements: Entitlements? = .file(path: .relativeToRoot("WidgetExtension.entitlements"))
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
        self.entitlements = entitlements
    }
}


extension Target {
    public static func makeModular(extenions layer: ExtensionsLayer, factory: ModularFactory) -> Target {
        switch layer {
        case .Widget:
          return Target
            .target(
              name: layer.rawValue + "Extension",
              destinations: factory.destionation,
              product: factory.products.isExtensions ? .appExtension : .app,
              bundleId: factory.bundleId.lowercased(),
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
            return Target
                .target(
                    name: layer.rawValue,
                    destinations: factory.destionation,
                    product: factory.products.isApp ? .app : .staticLibrary,
                    bundleId: factory.bundleId.lowercased(),
                    deploymentTargets: factory.deploymentTarget,
                    infoPlist: factory.infoPlist,
                    sources: factory.sources,
                    resources: factory.resources,
                    entitlements: factory.entitlements,
                    dependencies: factory.dependencies,
                    settings: factory.settings
                )
        case .Data:
            return Target
                .target(
                    name: layer.rawValue,
                    destinations: factory.destionation,
                    product: factory.products.isExtensions ? .staticFramework : .framework,
                    bundleId: factory.bundleId.lowercased(),
                    deploymentTargets: factory.deploymentTarget,
                    infoPlist: factory.infoPlist,
                    sources: factory.sources,
                    resources: factory.resources,
                    entitlements: .none,
                    dependencies: factory.dependencies,
                    settings: factory.settings
                )
        case .Domain:
            return Target
                .target(
                    name: layer.rawValue,
                    destinations: factory.destionation,
                    product: factory.products.isExtensions ? .staticFramework : .framework,
                    bundleId: factory.bundleId.lowercased(),
                    deploymentTargets: factory.deploymentTarget,
                    infoPlist: factory.infoPlist,
                    sources: factory.sources,
                    resources: factory.resources,
                    entitlements: .none,
                    dependencies: factory.dependencies,
                    settings: factory.settings
                )
        case .Core:
            return Target
                .target(
                    name: layer.rawValue,
                    destinations: factory.destionation,
                    product: factory.products.isExtensions ? .framework : .staticFramework,
                    bundleId: factory.bundleId.lowercased(),
                    deploymentTargets: factory.deploymentTarget,
                    infoPlist: factory.infoPlist,
                    sources: factory.sources,
                    resources: factory.resources,
                    entitlements: .none,
                    dependencies: factory.dependencies,
                    settings: factory.settings
                )
        case .DesignSystem:
            return Target
                .target(
                    name: layer.rawValue,
                    destinations: factory.destionation,
                    product: factory.products.isExtensions ? .staticFramework : .framework,
                    bundleId: factory.bundleId.lowercased(),
                    deploymentTargets: factory.deploymentTarget,
                    infoPlist: factory.infoPlist,
                    sources: factory.sources,
                    resources: factory.resources,
                    entitlements: .none,
                    dependencies: factory.dependencies,
                    settings: factory.settings
                )
        }
        
    }
    
}
