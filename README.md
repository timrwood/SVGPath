![SVGPath](https://cloud.githubusercontent.com/assets/643885/5913982/181a66d4-a5a2-11e4-8939-aed6ca190982.png)

[![MIT License][license-image]][license-url] [![Build Status][travis-image]][travis-url] [![SVGPath on CocoaPods][cocoapods-image]][cocoapods-url]

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

[license-image]: https://img.shields.io/cocoapods/l/SVGPath.svg?style=flat
[license-url]: https://github.com/timrwood/SVGPath/blob/master/LICENSE

[travis-image]: http://img.shields.io/travis/timrwood/SVGPath.svg?style=flat
[travis-url]: http://travis-ci.org/timrwood/SVGPath

[cocoapods-image]: https://img.shields.io/cocoapods/v/SVGPath.svg?style=flat
[cocoapods-url]: http://cocoadocs.org/docsets/SVGPath
