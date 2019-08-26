// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "NiceHTML",
  products: [
    .library(name: "NiceHTML", targets: ["NiceHTML"]),
    .library(name: "NiceHTMLStream", targets: ["NiceHTMLStream"])
  ],
  targets: [
    .target(name: "NiceHTMLStream"),
    .target(name: "NiceHTML", dependencies: ["NiceHTMLStream"]),
    .testTarget(name: "NiceHTMLTests", dependencies: ["NiceHTML", "NiceHTMLStream"]),
  ]
)
