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
        products: [ProductsType] = [.app, .uiTests, .unitTests],
        dependencies: [TargetDependency] = [],
        bundleId: String,
        deploymentTarget: DeploymentTarget? = .defualt,
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
        //TODO: Scheme 추가 예정 or 디버깅용 print 구문 추후 삭제 예정
        print("🤩 MAKE APP PROEJCT 🤩")
        print("📝 MAKE APP PROJET NAME \(name) 📝")
        print("🥳 MAKE APP PROJET RESOURCES  \(target.first?.resources) 🥳")
        print("🥰 MAKE APP PROJECT SOURCES \(target.first?.sources) 🧐")
        print("🧐 MAKE APP PROJECT BUNDLEID \(target.first?.bundleId) 🧐")
        print("💁‍♂️ MAKE APP PROJECT DEPENDENCIES \(target.first?.dependencies)")
        print("🫡 MAKE APP PROJECT PRODUCTTYPE \(target.first?.product)")
        return Project(
            name: name,
            targets: target
        )
    }
    
    
}
