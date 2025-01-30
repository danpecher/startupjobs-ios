import ProjectDescription
// import ProjectDescriptionHelpers

let deploymentTarget: SettingValue = "17.0"

let frameworks: [(String, [TargetDependency])] = [
    ("AppFramework", []),
    ("Networking", []),
]

let frameworkTargets: [Target] = frameworks.map { (name, dependencies) in
    [
        Target.target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: "human.dan.\(name.lowercased())",
            sources: ["Packages/\(name)/Sources/**"],
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": deploymentTarget,
                ]
            )
        ),
        Target.target(
            name: "\(name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "human.dan.\(name.lowercased())Tests",
            sources: ["Packages/\(name)/Tests/**"],
            dependencies: dependencies + [ .target(name: name) ],
            settings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": deploymentTarget,
                ]
            )
        )
    ]
}.flatMap { $0 }

let project = Project(
    name: "startupjobs",
    targets: [
        .target(
            name: "StartupJobs",
            destinations: .iOS,
            product: .app,
            bundleId: "human.dan.startupjobs",
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                                ]
                            ]
                        ]
                    ],
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["startupjobs/Sources/**"],
            resources: ["startupjobs/Resources/**"],
            dependencies: frameworks.map { .target(name: $0.0) } + [
                .external(name: "Nuke"),
                .external(name: "NukeUI"),
            ],
            settings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": deploymentTarget,
                ]
            )
        ),
        .target(
            name: "StartupJobsTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "human.dan.startupjobsTests",
            infoPlist: .default,
            sources: ["startupjobs/Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "StartupJobs"),
                .external(name: "Mocker")
            ],
            settings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": deploymentTarget,
                ]
            )
        )
    ] + frameworkTargets
)
