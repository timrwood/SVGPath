//
//  SVGCommandTests.swift
//  SVGPath
//
//  Created by Tim Wood on 1/25/15.
//  Copyright (c) 2015 Tim Wood. All rights reserved.
//

import XCTest
import SVGPath

class SVGCommandTests: XCTestCase {
    func testCommandFromTwoNumbers() {
        XCTAssertEqual(SVGCommand(1.0, 2.0, type: .Line).point,    CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 2 numbers for point")
        XCTAssertEqual(SVGCommand(1.0, 2.0, type: .Line).control1, CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 2 numbers for control1")
        XCTAssertEqual(SVGCommand(1.0, 2.0, type: .Line).control2, CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 2 numbers for control2")
    }

    func testCommandFromOnePoint() {
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), type: .Line).point,    CGPoint(x: 1.0, y: 2.0), "use 1st 1 of 1 points for point")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), type: .Line).control1, CGPoint(x: 1.0, y: 2.0), "use 1st 1 of 1 points for control1")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), type: .Line).control2, CGPoint(x: 1.0, y: 2.0), "use 1st 1 of 1 points for control2")
    }
    
    func testCommandFromFourNumbers() {
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0, type: .Line).point,    CGPoint(x: 3.0, y: 4.0), "use 2nd 2 of 4 numbers for point")
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0, type: .Line).control1, CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 4 numbers for control1")
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0, type: .Line).control2, CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 4 numbers for control2")
    }
    
    func testCommandFromTwoPoints() {
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), type: .Line).point,    CGPoint(x: 3.0, y: 4.0), "use 2nd 1 of 2 points for point")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), type: .Line).control1, CGPoint(x: 1.0, y: 2.0), "use 1st 1 of 2 points for control1")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), type: .Line).control2, CGPoint(x: 1.0, y: 2.0), "use 1st 1 of 2 points for control2")
    }
    
    func testCommandFromSixNumbers() {
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, type: .Line).point,    CGPoint(x: 5.0, y: 6.0), "use 3rd 2 of 6 numbers for point")
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, type: .Line).control1, CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 6 numbers for control1")
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, type: .Line).control2, CGPoint(x: 3.0, y: 4.0), "use 2nd 2 of 6 numbers for control2")
    }
    
    func testCommandFromThreePoints() {
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), CGPoint(x: 5.0, y: 6.0), type: .Line).point,    CGPoint(x: 5.0, y: 6.0), "use 3rd 1 of 3 points for point")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), CGPoint(x: 5.0, y: 6.0), type: .Line).control1, CGPoint(x: 1.0, y: 2.0), "use 1st 1 of 3 points for control1")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), CGPoint(x: 5.0, y: 6.0), type: .Line).control2, CGPoint(x: 3.0, y: 4.0), "use 2nd 1 of 3 points for control2")
    }
}
