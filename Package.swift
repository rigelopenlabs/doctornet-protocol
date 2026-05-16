// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "doctornet-protocol",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(name: "DoctorNetProtocol", targets: ["DoctorNetProtocol"]),
    ],
    targets: [
        .target(name: "DoctorNetProtocol", path: "Sources/DoctorNetProtocol"),
        .testTarget(
            name: "DoctorNetProtocolTests",
            dependencies: ["DoctorNetProtocol"]
        ),
    ]
)
