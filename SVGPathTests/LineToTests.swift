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
            SVGCommand(CGPoint(x: 1.0, y:2.0), type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleMoveToSameCommand() {
        let actual:[SVGCommand] = SVGPath("L1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 1.0, y:2.0), type: .Line),
            SVGCommand(CGPoint(x: 3.0, y:4.0), type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleMoveToNewCommands() {
        let actual:[SVGCommand] = SVGPath("L1 2L3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 1.0, y:2.0), type: .Line),
            SVGCommand(CGPoint(x: 3.0, y:4.0), type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testMultipleMoveToRelative() {
        let actual:[SVGCommand] = SVGPath("L1 2l1 2l5 6 1 1").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 1.0, y:2.0), type: .Line),
            SVGCommand(CGPoint(x: 2.0, y:4.0), type: .Line),
            SVGCommand(CGPoint(x: 7.0, y:10.0), type: .Line),
            SVGCommand(CGPoint(x: 8.0, y:11.0), type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testHorizontalLineToAbsolute () {
        let actual:[SVGCommand] = SVGPath("M1 2H4H-2 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 1.0, y:2.0), type: .Move),
            SVGCommand(CGPoint(x: 4.0, y:2.0), type: .Line),
            SVGCommand(CGPoint(x:-2.0, y:2.0), type: .Line),
            SVGCommand(CGPoint(x: 6.0, y:2.0), type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testHorizontalLineToRelative () {
        let actual:[SVGCommand] = SVGPath("M1 2h4h-2 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 1.0, y:2.0), type: .Move),
            SVGCommand(CGPoint(x: 5.0, y:2.0), type: .Line),
            SVGCommand(CGPoint(x: 3.0, y:2.0), type: .Line),
            SVGCommand(CGPoint(x: 9.0, y:2.0), type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testVerticalLineToAbsolute () {
        let actual:[SVGCommand] = SVGPath("M1 2V4V-2 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 1.0, y: 2.0), type: .Move),
            SVGCommand(CGPoint(x: 1.0, y: 4.0), type: .Line),
            SVGCommand(CGPoint(x: 1.0, y:-2.0), type: .Line),
            SVGCommand(CGPoint(x: 1.0, y: 6.0), type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
    
    func testVerticalLineToRelative () {
        let actual:[SVGCommand] = SVGPath("M1 2v4v-2 6").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 1.0, y: 2.0), type: .Move),
            SVGCommand(CGPoint(x: 1.0, y: 6.0), type: .Line),
            SVGCommand(CGPoint(x: 1.0, y: 4.0), type: .Line),
            SVGCommand(CGPoint(x: 1.0, y:10.0), type: .Line)
        ]
        
        assertCommandsEqual(actual, expect)
    }
}
