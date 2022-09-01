// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "graphql-swift",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "graphql-swift",
            targets: ["graphql-swift"]),
        .library(
            name: "graphql-codegen",
            targets: ["graphql-codegen", "graphql-swift"]),
        .executable(
            name: "codegen-results",
            targets: ["codegen-results", "graphql-swift"]),
        .executable(
            name: "local-run-codegen",
            targets: ["local-run-codegen", "graphql-codegen"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "graphql-swift",
            dependencies: []),
        .target(
            name: "graphql-codegen",
            dependencies: ["graphql-swift"]),
        .executableTarget(
            name: "codegen-results",
            dependencies: ["graphql-swift"]),
        .executableTarget(
            name: "local-run-codegen",
            dependencies: ["graphql-swift", "graphql-codegen"]),
        .testTarget(
            name: "graphql-swiftTests",
            dependencies: ["graphql-swift"]),
    ]
)
