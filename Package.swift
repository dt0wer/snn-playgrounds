// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SNNPlayground",
	platforms: [
		.macOS(.v15)
	],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
		.executable(name: "SNNPlayground", targets: ["SNNPlayground"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "SNNPlayground",
			dependencies: ["SNN"],
			sources: ["ContentView.swift", "SNNPlayground.swift"],
			resources: [
				.process("Resources")
			],
			swiftSettings: [.define("APP_PLAYGROUND")]
		),
		.target(
			name: "SNN"),
    ]
)
