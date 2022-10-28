// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZipArchive",
    platforms: [
        .iOS("15.0"),
        .tvOS("15.4"),
        .macOS(.v10_15),
        .watchOS("8.4"),
        .macCatalyst("13.0")
    ],
    products: [
        .library(name: "ZipArchive-dynamic", type: .dynamic, targets: ["ZipArchive"]),
        .library(name: "ZipArchive", type: .static, targets: ["ZipArchive"]),
        .library(name: "Flatty-dynamic", type: .dynamic, targets: ["flatty"]),
        .library(name: "Flatty", type: .static, targets: ["flatty"]),
    ],
    dependencies: [
        .package(url: "https://github.com/awxkee/zstd.swift.git", "1.0.0"..<"2.0.0"),
        .package(url: "https://github.com/awxkee/liblzma.swift.git", "1.0.0"..<"2.0.0")
    ],
    targets: [
        .target(name: "flatty", dependencies: [.target(name: "ZipArchive")], path: "flatty"),
        .target(
            name: "ZipArchive",
            dependencies: ["libminizip",
                           .product(name: "libzstd", package: "zstd.swift"),
                           .product(name: "liblzma", package: "liblzma.swift")],
            path: "SSZipArchive",
            cSettings: [
                .define("HAVE_INTTYPES_H"),
                .define("HAVE_PKCRYPT"),
                .define("HAVE_STDINT_H"),
                .define("HAVE_WZAES"),
                .define("HAVE_ZLIB"),
                .define("HAVE_LIBCOMP"),
                .define("HAVE_LZMA"),
                .define("HAVE_ZSTD"),
                .define("HAVE_BZIP2"),
                .define("ZLIB_COMPAT")
            ],
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedLibrary("bz2"),
                .linkedLibrary("iconv"),
                .linkedLibrary("compression"),
                .linkedFramework("Security"),
            ]
        ),
        .binaryTarget(name: "libminizip", path: "SSZipArchive/minizip/libminizip.xcframework"),
    ]
)
