// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarketSupaBaseService",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MarketSupaBaseService",
            targets: ["MarketSupaBaseService"]),
    ],
    dependencies: [
            .package(
                url: "https://github.com/supabase/supabase-swift.git",
                from: "2.0.0"
            ),
        ],
    targets: [
        .target(
            name: "MarketSupaBaseService",
                dependencies: [
                    .product(
                        name: "Supabase", // Auth, Realtime, Postgrest, Functions, or Storage
                        package: "supabase-swift"
                    ),
                ]
            )
    ]
)
