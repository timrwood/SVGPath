//
//  LineToTests.swift
//  SVGPath
//
//  Created by Tim Wood on 1/22/15.
//  Copyright (c) 2015 Tim Wood. All rights reserved.
//

import XCTest
import SVGPath

class LineToTests: XCTestCase {
    func testSingleMoveTo() {
        let actual:[SVGCommand] = SVGPath("L1 2").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleMoveToSameCommand() {
        let actual:[SVGCommand] = SVGPath("L1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Line),
            SVGCommand(3.0, 4.0, type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleMoveToNewCommands() {
        let actual:[SVGCommand] = SVGPath("L1 2L3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Line),
            SVGCommand(3.0, 4.0, type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleMoveToRelative() {
        let actual:[SVGCommand] = SVGPath("L1 2l1 2l5 6 1 1").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0,  2.0, type: .Line),
            SVGCommand(2.0,  4.0, type: .Line),
            SVGCommand(7.0, 10.0, type: .Line),
            SVGCommand(8.0, 11.0, type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testHorizontalLineToAbsolute () {
        let actual:[SVGCommand] = SVGPath("M1 2H4H-2 6").commands
        let expect:[SVGCommand] = [
            SVGCommand( 1.0, 2.0, type: .Move),
            SVGCommand( 4.0, 2.0, type: .Line),
            SVGCommand(-2.0, 2.0, type: .Line),
            SVGCommand( 6.0, 2.0, type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testHorizontalLineToRelative () {
        let actual:[SVGCommand] = SVGPath("M1 2h4h-2 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Move),
            SVGCommand(5.0, 2.0, type: .Line),
            SVGCommand(3.0, 2.0, type: .Line),
            SVGCommand(9.0, 2.0, type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testVerticalLineToAbsolute () {
        let actual:[SVGCommand] = SVGPath("M1 2V4V-2 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0,  2.0, type: .Move),
            SVGCommand(1.0,  4.0, type: .Line),
            SVGCommand(1.0, -2.0, type: .Line),
            SVGCommand(1.0,  6.0, type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testVerticalLineToRelative () {
        let actual:[SVGCommand] = SVGPath("M1 2v4v-2 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0,  2.0, type: .Move),
            SVGCommand(1.0,  6.0, type: .Line),
            SVGCommand(1.0,  4.0, type: .Line),
            SVGCommand(1.0, 10.0, type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
}
