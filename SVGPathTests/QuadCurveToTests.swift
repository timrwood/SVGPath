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
            SVGCommand(CGPoint(x: 1.0, y:2.0), CGPoint(x: 3.0, y:4.0), type: .QuadCurve)
        ]
        
        assertCommandsEqual(actual, expect)
    }
}