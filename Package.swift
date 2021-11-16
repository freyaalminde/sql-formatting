// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "sql-formatting",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
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
      exclude: ["node_modules", "package.json", "yarn.lock"],
      resources: [.copy("PGMinify.js"), .copy("SQLFormatter.js")]
    ),
    .testTarget(
      name: "SQLFormattingTests",
      dependencies: ["SQLFormatting"]
    ),
  ]
)
