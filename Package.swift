// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "sql-formatting",
  platforms: [
    .macOS(.v10_10),
    .iOS(.v8),
    .tvOS(.v9),
  ],
  products: [
    .library(
      name: "SQLFormatting",
      targets: ["SQLFormatting"]
    ),
  ],
  targets: [
    .target(
      name: "SQLFormatting",
      exclude: ["Documentation.docc", "node_modules", "node_modules/.gitkeep", "package.json", "yarn.lock"],
      resources: [.copy("PGMinify.js"), .copy("SQLFormatter.js")]
    ),
    .testTarget(
      name: "SQLFormattingTests",
      dependencies: ["SQLFormatting"]
    ),
  ]
)
