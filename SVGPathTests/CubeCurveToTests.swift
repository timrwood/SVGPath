//
//  CubeCurveToTests.swift
//  SVGPath
//
//  Created by Tim Wood on 1/25/15.
//  Copyright (c) 2015 Tim Wood. All rights reserved.
//

import XCTest
import SVGPath

class CubeCurveToTests: XCTestCase {
    func testSingleAbsoluteCurveTo() {
        let actual:[SVGCommand] = SVGPath("C1 2 3 4 5 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleAbsoluteCurveTo() {
        let actual:[SVGCommand] = SVGPath("C1 2 3 4 5 6 7 8 9 10 11 12C13 14 15 16 17 18").commands
        let expect:[SVGCommand] = [
            SVGCommand( 1.0,  2.0,  3.0,  4.0,  5.0,  6.0),
            SVGCommand( 7.0,  8.0,  9.0, 10.0, 11.0, 12.0),
            SVGCommand(13.0, 14.0, 15.0, 16.0, 17.0, 18.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testSingleRelativeCurveTo() {
        let actual:[SVGCommand] = SVGPath("M8 6c1 2 3 4 5 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(8.0, 6.0, type: .move),
            SVGCommand(9.0, 8.0, 11.0, 10.0, 13.0, 12.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleRelativeCurveTo() {
        let actual:[SVGCommand] = SVGPath("M1 2c3 4 5 6 7 8 9 10 11 12 13 14c1 2 3 4 5 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(
                1.0,                   2.0, type: .move),
            SVGCommand(
                1.0 + 3.0,             2.0 + 4.0,
                1.0 + 5.0,             2.0 + 6.0,
                1.0 + 7.0,             2.0 + 8.0),
            SVGCommand(
                1.0 + 7.0 +  9.0,       2.0 + 8.0 + 10.0,
                1.0 + 7.0 + 11.0,       2.0 + 8.0 + 12.0,
                1.0 + 7.0 + 13.0,       2.0 + 8.0 + 14.0),
            SVGCommand(
                1.0 + 7.0 + 13.0 + 1.0, 2.0 + 8.0 + 14.0 + 2.0,
                1.0 + 7.0 + 13.0 + 3.0, 2.0 + 8.0 + 14.0 + 4.0,
                1.0 + 7.0 + 13.0 + 5.0, 2.0 + 8.0 + 14.0 + 6.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testSingleAbsoluteSmoothCurveTo() {
        let actual:[SVGCommand] = SVGPath("C1 2 3 4 5 6S7 8 9 10").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0,  6.0),
            SVGCommand(7.0, 8.0, 7.0, 8.0, 9.0, 10.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleAbsoluteSmoothCurveTo() {
        let actual:[SVGCommand] = SVGPath("C1 2 3 4 5 6S1 2 3 4 5 6 7 8").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0),
            SVGCommand(7.0, 8.0, 1.0, 2.0, 3.0, 4.0),
            SVGCommand(5.0, 6.0, 5.0, 6.0, 7.0, 8.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }

    func testSingleRelativeSmoothCurveTo() {
        let actual:[SVGCommand] = SVGPath("C1 2 3 4 5 6s7 8 9 10").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0,  3.0,  4.0,  5.0,  6.0),
            SVGCommand(7.0, 8.0, 12.0, 14.0, 14.0, 16.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleRelativeSmoothCurveTo() {
        let actual:[SVGCommand] = SVGPath("C1 2 3 4 5 6s1 2 3 4 5 6 7 8").commands
        let expect:[SVGCommand] = [
            SVGCommand( 1.0,  2.0,  3.0,  4.0,  5.0,  6.0),
            SVGCommand( 7.0,  8.0,  6.0,  8.0,  8.0, 10.0),
            SVGCommand(10.0, 12.0, 13.0, 16.0, 15.0, 18.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }

    func testAbsoluteSmoothToAfterMoveTo() {
        let actual:[SVGCommand] = SVGPath("M1 2S3 4 5 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .move),
            SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testAbsoluteSmoothToAfterLineTo() {
        let actual:[SVGCommand] = SVGPath("L1 2S3 4 5 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .line),
            SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testAbsoluteSmoothToAfterQuadCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4S5 6 7 8").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0, 4.0),
            SVGCommand(3.0, 4.0, 5.0, 6.0, 7.0, 8.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testRelativeSmoothToAfterMoveTo() {
        let actual:[SVGCommand] = SVGPath("M1 2s3 4 5 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .move),
            SVGCommand(1.0, 2.0, 4.0, 6.0, 6.0, 8.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testRelativeSmoothToAfterLineTo() {
        let actual:[SVGCommand] = SVGPath("L1 2s3 4 5 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .line),
            SVGCommand(1.0, 2.0, 4.0, 6.0, 6.0, 8.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testRelativeSmoothToAfterQuadCurveTo() {
        let actual:[SVGCommand] = SVGPath("Q1 2 3 4s5 6 7 8").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0,  4.0),
            SVGCommand(3.0, 4.0, 8.0, 10.0, 10.0, 12.0)
        ]
        
        assertCommandsEqual(actual, expect)
    }
}
