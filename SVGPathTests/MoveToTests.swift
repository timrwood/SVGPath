//
//  MoveToTests.swift
//  SVGPath
//
//  Created by Tim Wood on 1/22/15.
//  Copyright (c) 2015 Tim Wood. All rights reserved.
//

import XCTest
import SVGPath

class MoveToTests: XCTestCase {
    func testSingleMoveTo() {
        let actual:[SVGCommand] = SVGPath("M1 2").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Move)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleMoveToSameCommand() {
        let actual:[SVGCommand] = SVGPath("M1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Move),
            SVGCommand(3.0, 4.0, type: .Move)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleMoveToNewCommands() {
        let actual:[SVGCommand] = SVGPath("M1 2M3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Move),
            SVGCommand(3.0, 4.0, type: .Move)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleMoveToRelative() {
        let actual:[SVGCommand] = SVGPath("M1 2m1 2m5 6 1 1").commands
        let expect:[SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .Move),
            SVGCommand(2.0, 4.0, type: .Move),
            SVGCommand(7.0, 10.0, type: .Move),
            SVGCommand(8.0, 11.0, type: .Move)
        ]
        
        assertCommandsEqual(actual, expect)
    }
}
