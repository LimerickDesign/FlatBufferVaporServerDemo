// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "VaporFlatBufferDemo",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "Run", targets: ["Run"]),
        .library(name: "VaporFlatBufferDemo", targets: ["VaporFlatBufferDemo"]),
    ],
    dependencies: [
        .package(name: "vapor", url: "https://github.com/vapor/vapor.git", .exact("4.0.0-rc.3.7")),
        .package(name: "FlatBuffers", url: "https://github.com/mustiikhalil/flatbuffers.git", .branch("swift")),
    ],
    targets: [
        .target(name: "Run", dependencies: [
            .target(name: "VaporFlatBufferDemo")
        ]),
        .target(name: "VaporFlatBufferDemo", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "FlatBuffers", package: "FlatBuffers"),
        ]),
        .testTarget(name: "VaporFlatBufferDemoTests", dependencies: ["VaporFlatBufferDemo"]),
    ]
)
