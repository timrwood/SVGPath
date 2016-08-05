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
    func testCommandFromZeroNumbers() {
        XCTAssertEqual(SVGCommand().point,    CGPoint(x: 0.0, y: 0.0), "use 0,0 for point")
        XCTAssertEqual(SVGCommand().control1, CGPoint(x: 0.0, y: 0.0), "use 0,0 for control1")
        XCTAssertEqual(SVGCommand().control2, CGPoint(x: 0.0, y: 0.0), "use 0,0 for control2")
        XCTAssertEqual(SVGCommand().type,     SVGCommand.Kind.close,   "use close type for 0 numbers")
    }

    func testCommandFromTwoNumbers() {
        XCTAssertEqual(SVGCommand(1.0, 2.0, type: .line).point,    CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 2 numbers for point")
        XCTAssertEqual(SVGCommand(1.0, 2.0, type: .line).control1, CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 2 numbers for control1")
        XCTAssertEqual(SVGCommand(1.0, 2.0, type: .line).control2, CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 2 numbers for control2")
        XCTAssertEqual(SVGCommand(1.0, 2.0, type: .line).type,     SVGCommand.Kind.line, "use the provided kind for 2 numbers")
        XCTAssertEqual(SVGCommand(1.0, 2.0, type: .move).type,     SVGCommand.Kind.move, "use the provided kind for 2 numbers")
    }
    
    func testCommandFromFourNumbers() {
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0).point,    CGPoint(x: 3.0, y: 4.0), "use 2nd 2 of 4 numbers for point")
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0).control1, CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 4 numbers for control1")
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0).control2, CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 4 numbers for control2")
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0).type,     SVGCommand.Kind.quadCurve, "use quad curve type for 4 numbers")
    }
    
    func testCommandFromSixNumbers() {
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0).point,    CGPoint(x: 5.0, y: 6.0), "use 3rd 2 of 6 numbers for point")
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0).control1, CGPoint(x: 1.0, y: 2.0), "use 1st 2 of 6 numbers for control1")
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0).control2, CGPoint(x: 3.0, y: 4.0), "use 2nd 2 of 6 numbers for control2")
        XCTAssertEqual(SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0).type,     SVGCommand.Kind.cubeCurve, "use cube curve type for 6 numbers")
    }
    
    func testCommandFromThreePoints() {
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), CGPoint(x: 5.0, y: 6.0), type: .line).point,     CGPoint(x: 5.0, y: 6.0),   "use 3rd 1 of 3 points for point")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), CGPoint(x: 5.0, y: 6.0), type: .line).control1,  CGPoint(x: 1.0, y: 2.0),   "use 1st 1 of 3 points for control1")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), CGPoint(x: 5.0, y: 6.0), type: .line).control2,  CGPoint(x: 3.0, y: 4.0),   "use 2nd 1 of 3 points for control2")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), CGPoint(x: 5.0, y: 6.0), type: .line).type,      SVGCommand.Kind.line,      "use provided kind for 3 points")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), CGPoint(x: 5.0, y: 6.0), type: .move).type,      SVGCommand.Kind.move,      "use provided kind for 3 points")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), CGPoint(x: 5.0, y: 6.0), type: .quadCurve).type, SVGCommand.Kind.quadCurve, "use provided kind for 3 points")
        XCTAssertEqual(SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 3.0, y: 4.0), CGPoint(x: 5.0, y: 6.0), type: .cubeCurve).type, SVGCommand.Kind.cubeCurve, "use provided kind for 3 points")
    }
}
