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
            SVGCommand(CGPoint(x: 3.0, y: 4.0), CGPoint(x: 1.0, y: 2.0), type: .QuadCurve)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleAbsoluteCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4 5 6 7 8Q1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 3.0, y: 4.0), CGPoint(x: 1.0, y: 2.0), type: .QuadCurve),
            SVGCommand(CGPoint(x: 7.0, y: 8.0), CGPoint(x: 5.0, y: 6.0), type: .QuadCurve),
            SVGCommand(CGPoint(x: 3.0, y: 4.0), CGPoint(x: 1.0, y: 2.0), type: .QuadCurve)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testSingleRelativeCurveTo() {
        let actual:[SVGCommand] = SVGPath("M8 6q1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 8.0, y: 6.0), type: .Move),
            SVGCommand(CGPoint(x: 11.0, y: 10.0), CGPoint(x: 9.0, y: 8.0), type: .QuadCurve)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleRelativeCurveTo() {
        let actual:[SVGCommand] = SVGPath("M1 2q3 4 5 6 7 8 9 10q1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(
                CGPoint(x: 1.0,                   y: 2.0), type: .Move),
            SVGCommand(
                CGPoint(x: 1.0 + 5.0,             y: 2.0 + 6.0),
                CGPoint(x: 1.0 + 3.0,             y: 2.0 + 4.0), type: .QuadCurve),
            SVGCommand(
                CGPoint(x: 1.0 + 5.0 + 9.0,       y: 2.0 + 6.0 + 10.0),
                CGPoint(x: 1.0 + 5.0 + 7.0,       y: 2.0 + 6.0 + 8.0), type: .QuadCurve),
            SVGCommand(
                CGPoint(x: 1.0 + 5.0 + 9.0 + 3.0, y: 2.0 + 6.0 + 10.0 + 4.0),
                CGPoint(x: 1.0 + 5.0 + 9.0 + 1.0, y: 2.0 + 6.0 + 10.0 + 2.0), type: .QuadCurve)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testSingleAbsoluteSmoothCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4T7 8").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 3.0, y: 4.0), CGPoint(x: 1.0, y: 2.0), type: .QuadCurve),
            SVGCommand(CGPoint(x: 7.0, y: 8.0), CGPoint(x: 5.0, y: 6.0), type: .QuadCurve)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleAbsoluteSmoothCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4T1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 3.0, y: 4.0), CGPoint(x: 1.0, y: 2.0), type: .QuadCurve),
            SVGCommand(CGPoint(x: 1.0, y: 2.0), CGPoint(x: 5.0, y: 6.0), type: .QuadCurve),
            SVGCommand(CGPoint(x: 3.0, y: 4.0), CGPoint(x:-3.0, y:-2.0), type: .QuadCurve)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testSingleRelativeSmoothCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4t7 8").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x:  3.0, y:  4.0), CGPoint(x: 1.0, y: 2.0), type: .QuadCurve),
            SVGCommand(CGPoint(x: 10.0, y: 12.0), CGPoint(x: 5.0, y: 6.0), type: .QuadCurve)
        ]
        
        assertCommandsEqual(actual, expect)
    }
}