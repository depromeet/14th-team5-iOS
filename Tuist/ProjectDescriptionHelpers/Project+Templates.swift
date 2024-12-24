import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

public struct AppFactory {
    var name: String
    var platform: Platform
    var products: [ProductsType]
    var dependencies: [TargetDependency]
    var bundleId: String
    var deploymentTarget: DeploymentTargets?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var settings: Settings?
    var entitlements: Path?
    var scripts: [TargetScript]
    
    
    public init(
        name: String = "bibbi",
        platform: Platform = .iOS,
        products: [ProductsType] = [.app, .uiTests, .unitTests],
        dependencies: [TargetDependency] = [],
        bundleId: String,
        deploymentTarget: DeploymentTargets? = .defualt,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = .default,
        resources: ResourceFileElements? = .default,
        settings: Settings? = nil,
        entitlements: Path? = nil,
        scripts: [TargetScript] = []
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


extension Project {
    public static func makeApp(name: String, target: [Target]) -> Project {
        return Project(
            name: name,
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": "$(inherited) -ObjC",
                    "MARKETING_VERSION": "1.2.5",
                    "CURRENT_PROJECT_VERSION": "1",
                    "VERSIONING_SYSTEM": "apple-generic"
                ],
                configurations: [
                    .build(.dev, name: name),
                    .build(.stg, name: name),
                    .build(.prd, name: name)
                ]
            ),
            targets: target,
            schemes: [
                .makeScheme(.dev, name: name),
                .makeScheme(.stg, name: name),
                .makeScheme(.prd, name: name)
            ],
            additionalFiles: [
                "../XCConfig/shared.xcconfig",
                "../XCConfig/hidden.xcconfig"
            ]
        )
    }
}
