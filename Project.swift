import ProjectDescription
// import ProjectDescriptionHelpers

let project = Project(
    name: "startupjobs",
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.startupjobs",
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
            dependencies: []
        ),
        .target(
            name: "startupjobsTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.startupjobsTests",
            infoPlist: .default,
            sources: ["startupjobs/Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "App"),
                .external(name: "Mocker")
            ]
        ),
    ]
)
