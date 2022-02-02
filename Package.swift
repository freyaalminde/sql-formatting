// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "sql-formatting",
  platforms: [
    .macOS(.v10_10),
    .iOS(.v9),
    .tvOS(.v9),
  ],
  products: [
    .library(
      name: "SQLFormatting",
      targets: ["SQLFormatting"]
    ),
  ],
  dependencies: [
    .package(name: "perl-core", url: "https://github.com/freyaariel/perl-core.git", .branch("main")),
  ],
  targets: [
    .target(
      name: "SQLFormatting",
      dependencies: [.product(name: "PerlCore", package: "perl-core", condition: .when(platforms: [.macOS]))],
      // TODO: remove `Documentation.docc` from here once we can use swift-tools-version:5.5 on GitHub
      exclude: ["Documentation.docc", "node_modules", "node_modules/.gitkeep", "package.json", "yarn.lock"],
      resources: [.copy("PGMinify.js"), .copy("PGFormatter.pm"), .copy("SQLFormatter.js")]
    ),
    .testTarget(
      name: "SQLFormattingTests",
      dependencies: ["SQLFormatting"]
    ),
  ]
)
