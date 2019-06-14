// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WallabagKit",
    products: [
        .library(
            name: "WallabagKit",
            targets: ["WallabagKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "WallabagKit",
            dependencies: ["Alamofire"],
            path: "Sources"
        ),
        .testTarget(
            name: "WallabagKitTests",
            dependencies: ["WallabagKit"]
        ),
    ]
)
