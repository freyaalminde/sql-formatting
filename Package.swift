// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "sql-formatting",
  platforms: [
    .macOS(.v10_10),
    .iOS(.v9),
    .tvOS(.v9),
    .watchOS(.v7),
  ],
  products: [
    .library(name: "SQLFormatting", targets: ["SQLFormatting"]),
  ],
  dependencies: [
    .package(name: "perl-core", url: "https://github.com/freyaariel/perl-core.git", branch: "feature/xcframework"),
  ],
  targets: [
    .target(
      name: "SQLFormatting",
      dependencies: [.product(name: "PerlCore", package: "perl-core")],
      exclude: ["node_modules", "package.json", "yarn.lock"],
      resources: [.copy("PGMinify.js"), .copy("PGFormatter.pm"), .copy("SQLFormatter.js")]
    ),
    .testTarget(
      name: "SQLFormattingTests",
      dependencies: ["SQLFormatting"]
    ),
  ]
)
