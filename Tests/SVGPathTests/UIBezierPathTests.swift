//
//  UIBezierPathTests.swift
//  SVGPath
//
//  Created by Tim Wood on 1/25/15.
//  Copyright (c) 2015 Tim Wood. All rights reserved.
//

import XCTest
import SwiftUI
import SVGPath

class UIBezierPathTests: XCTestCase {
    func testMoveAndLineTo() {
        //   234
        // 4 XXX
        // 5 XXX
        // 6 XXX

        let path = Path(svgPath: "M2 4L2 6 4 6 4 4Z")

        // 4 corners
        XCTAssert(path.contains(CGPoint(x: 2.01, y: 4.01)), "square should contain 2.01, 4.01")
        XCTAssert(path.contains(CGPoint(x: 3.99, y: 4.01)), "square should contain 3.99, 4.01")
        XCTAssert(path.contains(CGPoint(x: 3.99, y: 5.99)), "square should contain 3.99, 5.99")
        XCTAssert(path.contains(CGPoint(x: 2.01, y: 5.99)), "square should contain 2.01, 5.99")

        // just outside each corner
        XCTAssert(!path.contains(CGPoint(x: 1.99, y: 4.01)), "square should not contain 1.99, 4.01")
        XCTAssert(!path.contains(CGPoint(x: 4.01, y: 4.01)), "square should not contain 4.01, 4.01")
        XCTAssert(!path.contains(CGPoint(x: 1.99, y: 5.99)), "square should not contain 1.99, 5.99")
        XCTAssert(!path.contains(CGPoint(x: 4.01, y: 5.99)), "square should not contain 4.01, 5.99")
        XCTAssert(!path.contains(CGPoint(x: 2.01, y: 3.99)), "square should not contain 2.01, 3.99")
        XCTAssert(!path.contains(CGPoint(x: 3.99, y: 3.99)), "square should not contain 3.99, 3.99")
        XCTAssert(!path.contains(CGPoint(x: 3.99, y: 6.01)), "square should not contain 3.99, 6.01")
        XCTAssert(!path.contains(CGPoint(x: 2.01, y: 6.01)), "square should not contain 2.01, 6.01")
    }

    func testQuadCurveTo() {
        //   234
        // 4 Xx
        // 5 XXx
        // 6 XXX

        let path = Path(svgPath: "M2 4Q4 4 4 6L2 6Z")

        // 4 corners
        XCTAssert( path.contains(CGPoint(x: 2.01, y: 4.01)), "curve should contain 2.01, 4.01")
        XCTAssert(!path.contains(CGPoint(x: 3.99, y: 4.01)), "curve should not contain 3.99, 4.01")
        XCTAssert( path.contains(CGPoint(x: 3.99, y: 5.99)), "curve should contain 3.99, 5.99")
        XCTAssert( path.contains(CGPoint(x: 2.01, y: 5.99)), "curve should contain 2.01, 5.99")

        // either side of the halfway point of the curve
        XCTAssert( path.contains(CGPoint(x: 3.49, y: 4.51)), "curve should contain 3.49, 4.51")
        XCTAssert(!path.contains(CGPoint(x: 3.51, y: 4.49)), "curve should not contain 3.51, 4.49")
    }

    func testCubeCurveTo() {
        //   234
        // 4 Xx
        // 5 XXx
        // 6 Xx

        let path = Path(svgPath: "M2 4C4 4 4 6 2 6Z")

        // 4 corners
        XCTAssert( path.contains(CGPoint(x: 2.01, y: 4.01)), "curve should contain 2.01, 4.01")
        XCTAssert(!path.contains(CGPoint(x: 3.99, y: 4.01)), "curve should not contain 3.99, 4.01")
        XCTAssert(!path.contains(CGPoint(x: 3.99, y: 5.99)), "curve should not contain 3.99, 5.99")
        XCTAssert( path.contains(CGPoint(x: 2.01, y: 5.99)), "curve should contain 2.01, 5.99")

        // either side of the halfway point of the curve
        XCTAssert( path.contains(CGPoint(x: 3.49, y: 5)), "curve should contain 3.49, 5")
        XCTAssert(!path.contains(CGPoint(x: 3.51, y: 5)), "curve should not contain 3.51, 5")
    }

    func testClose() {
        //   2 3 4 5
        // 4 |X| |X|
        // 5 |X| |X|
        // 6 |X| |X|

        let path = Path(svgPath: "M3 6L3 4 2 4 2 6ZL4 4 5 4 5 6 4 6 4 4")

        // 4 corners left square
        XCTAssert(path.contains(CGPoint(x: 2.01, y: 4.01)), "square should contain 2.01, 4.01")
        XCTAssert(path.contains(CGPoint(x: 2.99, y: 4.01)), "square should contain 2.99, 4.01")
        XCTAssert(path.contains(CGPoint(x: 2.99, y: 5.99)), "square should contain 2.99, 5.99")
        XCTAssert(path.contains(CGPoint(x: 2.01, y: 5.99)), "square should contain 2.01, 5.99")

        // 4 corners right square
        XCTAssert(path.contains(CGPoint(x: 4.01, y: 4.01)), "square should contain 4.01, 4.01")
        XCTAssert(path.contains(CGPoint(x: 4.99, y: 4.01)), "square should contain 4.99, 4.01")
        XCTAssert(path.contains(CGPoint(x: 4.99, y: 5.99)), "square should contain 4.99, 5.99")
        XCTAssert(path.contains(CGPoint(x: 4.01, y: 5.99)), "square should contain 4.01, 5.99")

        // just outside each corner left
        XCTAssert(!path.contains(CGPoint(x: 1.99, y: 4.01)), "square should not contain 1.99, 4.01")
        XCTAssert(!path.contains(CGPoint(x: 3.01, y: 4.01)), "square should not contain 3.01, 4.01")
        XCTAssert(!path.contains(CGPoint(x: 1.99, y: 5.99)), "square should not contain 1.99, 5.99")
        XCTAssert(!path.contains(CGPoint(x: 3.01, y: 5.99)), "square should not contain 3.01, 5.99")
        XCTAssert(!path.contains(CGPoint(x: 2.01, y: 3.99)), "square should not contain 2.01, 3.99")
        XCTAssert(!path.contains(CGPoint(x: 2.99, y: 3.99)), "square should not contain 2.99, 3.99")
        XCTAssert(!path.contains(CGPoint(x: 2.99, y: 6.01)), "square should not contain 2.99, 6.01")
        XCTAssert(!path.contains(CGPoint(x: 2.01, y: 6.01)), "square should not contain 2.01, 6.01")

        // just outside each corner right
        XCTAssert(!path.contains(CGPoint(x: 3.99, y: 4.01)), "square should not contain 3.99, 4.01")
        XCTAssert(!path.contains(CGPoint(x: 5.01, y: 4.01)), "square should not contain 5.01, 4.01")
        XCTAssert(!path.contains(CGPoint(x: 3.99, y: 5.99)), "square should not contain 3.99, 5.99")
        XCTAssert(!path.contains(CGPoint(x: 5.01, y: 5.99)), "square should not contain 5.01, 5.99")
        XCTAssert(!path.contains(CGPoint(x: 4.01, y: 3.99)), "square should not contain 4.01, 3.99")
        XCTAssert(!path.contains(CGPoint(x: 4.99, y: 3.99)), "square should not contain 4.99, 3.99")
        XCTAssert(!path.contains(CGPoint(x: 4.99, y: 6.01)), "square should not contain 4.99, 6.01")
        XCTAssert(!path.contains(CGPoint(x: 4.01, y: 6.01)), "square should not contain 4.01, 6.01")
    }

    func testOffset() {
        // CubeCurve with an offset of -2.0, -2
        let path = Path(svgPath: "M2 4C4 4 4 6 2 6Z", offset: CGPoint(x: -2, y: -2))

        // 4 corners
        XCTAssert( path.contains(CGPoint(x: 0.01, y: 2.01)), "curve should contain 0.01, 2.01")
        XCTAssert(!path.contains(CGPoint(x: 1.99, y: 2.01)), "curve should not contain 1.99, 2.01")
        XCTAssert(!path.contains(CGPoint(x: 1.99, y: 3.99)), "curve should not contain 1.99, 3.99")
        XCTAssert( path.contains(CGPoint(x: 0.01, y: 3.99)), "curve should contain 0.01, 3.99")

        // either side of the halfway point of the curve
        XCTAssert( path.contains(CGPoint(x: 1.49, y: 3)), "curve should contain 1.49, 3")
        XCTAssert(!path.contains(CGPoint(x: 1.51, y: 3)), "curve should not contain 1.51, 3")
    }
}
