# SVGPath [![MIT License][license-image]][license-url] [![Build Status][travis-image]][travis-url]

A Swift Library for parsing SVG path strings into UIBezierPaths

# Installation

## CocoaPods

```ruby
pod 'SVGPath'
```

# Example

```swift
let path = UIBezierPath(svgPath: "M85 32C115 68 239 170 281 192 311 126 274 43 244 0c97 58 146 167 121 254 28 28 40 89 29 108 -25-45-67-39-93-24C176 409 24 296 0 233c68 56 170 65 226 27C165 217 56 89 36 54c42 38 116 96 161 122C159 137 108 72 85 32z")
```

[license-image]: http://img.shields.io/badge/license-MIT-blue.svg?style=flat
[license-url]: LICENSE

[travis-url]: http://travis-ci.org/timrwood/SVGPath
[travis-image]: http://img.shields.io/travis/timrwood/SVGPath/develop.svg?style=flat
