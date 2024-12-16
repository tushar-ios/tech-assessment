// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProductsService",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "ProductsService",
            targets: ["ProductsService"]
        ),
    ],
    targets: [
        .target(
            name: "ProductsService"
        ),
        .testTarget(
            name: "ProductsServiceTests",
            dependencies: ["ProductsService"]
        ),
    ]
)
