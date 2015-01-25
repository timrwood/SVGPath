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
            SVGCommand(1.0, 2.0, 3.0, 4.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleAbsoluteCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4 5 6 7 8Q1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0, 4.0),
            SVGCommand(5.0, 6.0, 7.0, 8.0),
            SVGCommand(1.0, 2.0, 3.0, 4.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testSingleRelativeCurveTo() {
        let actual:[SVGCommand] = SVGPath("M8 6q1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(8.0, 6.0, type: .Move),
            SVGCommand(9.0, 8.0, 11.0, 10.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleRelativeCurveTo() {
        let actual:[SVGCommand] = SVGPath("M1 2q3 4 5 6 7 8 9 10q1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(
                1.0,                   2.0, type: .Move),
            SVGCommand(
                1.0 + 3.0,             2.0 + 4.0,
                1.0 + 5.0,             2.0 + 6.0),
            SVGCommand(
                1.0 + 5.0 + 7.0,       2.0 + 6.0 + 8.0,
                1.0 + 5.0 + 9.0,       2.0 + 6.0 + 10.0),
            SVGCommand(
                1.0 + 5.0 + 9.0 + 1.0, 2.0 + 6.0 + 10.0 + 2.0,
                1.0 + 5.0 + 9.0 + 3.0, 2.0 + 6.0 + 10.0 + 4.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testSingleAbsoluteSmoothCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4T7 8").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0, 4.0),
            SVGCommand(5.0, 6.0, 7.0, 8.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleAbsoluteSmoothCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4T1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand( 1.0,  2.0, 3.0, 4.0),
            SVGCommand( 5.0,  6.0, 1.0, 2.0),
            SVGCommand(-3.0, -2.0, 3.0, 4.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testSingleRelativeSmoothCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4t7 8").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0,  3.0,  4.0),
            SVGCommand(5.0, 6.0, 10.0, 12.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleRelativeSmoothCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4t2 1 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0, 4.0),
            SVGCommand(5.0, 6.0, 5.0, 5.0),
            SVGCommand(5.0, 4.0, 8.0, 9.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testAbsoluteSmoothToAfterMoveTo() {
        let actual:[SVGCommand] = SVGPath("M1 2T3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Move),
            SVGCommand(1.0, 2.0, 3.0, 4.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testAbsoluteSmoothToAfterLineTo() {
        let actual:[SVGCommand] = SVGPath("L1 2T3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Line),
            SVGCommand(1.0, 2.0, 3.0, 4.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    // TODO: func testAbsoluteSmoothToAfterCubicCurveTo() {}
    
    func testRelativeSmoothToAfterMoveTo() {
        let actual:[SVGCommand] = SVGPath("M1 2t3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Move),
            SVGCommand(1.0, 2.0, 4.0, 6.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testRelativeSmoothToAfterLineTo() {
        let actual:[SVGCommand] = SVGPath("L1 2t3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Line),
            SVGCommand(1.0, 2.0, 4.0, 6.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    // TODO: func testRelativeSmoothToAfterCubicCurveTo() {}
}