//
//  Modular+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

import ProjectDescription


public struct ModularFactory {
    var name: String
    var platform: Platform
    var products: ProductsType
    var dependencies: [TargetDependency]
    var bundleId: String
    var deploymentTarget: DeploymentTarget?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var settings: Settings?
    
    
    init(
        name: String = "",
        platform: Platform = .iOS,
        products: ProductsType = .library(.static),
        dependencies: [TargetDependency],
        bundleId: String,
        deploymentTarget: DeploymentTarget? = nil,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = "Sources/**",
        resources: ResourceFileElements? = nil,
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


public struct AppFactory {
    var name: String
    var platform: Platform
    var products: ProductsType
    var dependencies: [TargetDependency]
    var bundleId: String
    var deploymentTarget: DeploymentTarget?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var settings: Settings?
    var entitlements: Path?
    var scripts: [TargetScript]
    
    
    public init(
        name: String = "App",
        platform: Platform = .iOS,
        products: ProductsType = .app,
        dependencies: [TargetDependency],
        bundleId: String,
        deploymentTarget: DeploymentTarget? = nil,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = "Sources/**",
        resources: ResourceFileElements? = nil,
        settings: Settings? = nil,
        entitlements: Path? = nil,
        scripts: [TargetScript]
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
        self.scripts = scripts
    }
    
    
}



public extension Target {
    //TODO: 모듈별 타켓 구현 예정
    static func makeModular(layer: ModuleLayer, factory: ModularFactory) -> Target {
        switch layer {
        case .App:
            <#code#>
        case .Data:
            <#code#>
        case .Domain:
            <#code#>
        case .Core:
            <#code#>
        case .DesignSystem:
            <#code#>
        }
        
    }
    
}
