// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherCore",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WeatherCore",
            targets: ["WeatherCore"]
        )
    ],
    dependencies: [
        .package(path: "../WeatherCommon")
    ],
    targets: [
        .target(
            name: "WeatherCore",
            dependencies: [
                .product(name: "WeatherCommon", package: "WeatherCommon")
            ]
        ),
        .testTarget(
            name: "WeatherCoreTests",
            dependencies: ["WeatherCore"]
        )
    ]
)
