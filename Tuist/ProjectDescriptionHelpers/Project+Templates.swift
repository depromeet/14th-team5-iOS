import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    public static func makeApp(name: String, target: [Target]) -> Project {
        return Project(
            name: name,
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": ["-ObjC"],
                    "MARKETING_VERSION": "1.0",
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
    
    
    public static func makeFrameWork(name: String, target: [Target]) -> Project {
        return Project(
            name: name,
            targets: target
        )
    }
}
