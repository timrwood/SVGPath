//
//  QuadCurveToTests.swift
//  SVGPath
//
//  Created by Tim Wood on 1/23/15.
//  Copyright (c) 2015 Tim Wood. All rights reserved.
//

import XCTest
import SVGPath

class QuadCurveToTests: XCTestCase {
    func testSingleAbsoluteCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 3.0, y:4.0), CGPoint(x: 1.0, y:2.0), type: .QuadCurve)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testSingleRelativeCurveTo() {
        let actual:[SVGCommand] = SVGPath("M8 6q1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 8.0, y:6.0), type: .Move),
            SVGCommand(CGPoint(x: 11.0, y:10.0), CGPoint(x: 9.0, y:8.0), type: .QuadCurve)
        ]
        
        assertCommandsEqual(actual, expect)
    }
}