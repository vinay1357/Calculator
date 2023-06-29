// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Calculator",
    platforms: [
           .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Calculator",
            targets: ["Calculator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vinay1357/ThemeKit.git", .branch("main")),
        
        .package(url: "https://github.com/vinay1357/CalculatorUIComponent", .branch("main"))

    ],

    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Calculator",
            dependencies: [
                .product(name: "ThemeKit", package: "ThemeKit", condition: nil),
                .product(name: "CalculatorUIComponent", package: "CalculatorUIComponent", condition: nil)
            ],
            resources: [.process("SourceFile")]
        ),
        .testTarget(
            name: "CalculatorTests",
            dependencies: ["Calculator"]),
    ]
)
