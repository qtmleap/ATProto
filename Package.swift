// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ATProto",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ATProto",
            targets: ["ATProto"],
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.2"),
        .package(url: "https://github.com/qtmleap/SwiftyLogger.git", from: "2.1.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ATProto",
            dependencies: [
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "SwiftyLogger", package: "SwiftyLogger"),
            ],
        ),
        .testTarget(
            name: "ATProtoTests",
            dependencies: [
                "ATProto",
            ],
            resources: [
                .process("JSON"),
            ],
        ),
    ],
)
