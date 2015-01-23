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
        
        XCTAssertEqual(actual, expect, "Should parse a single line to call")
    }
    
    func testMultipleMoveToSameCommand() {
        let actual:[SVGCommand] = SVGPath("L1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 1.0, y:2.0), type: .Line),
            SVGCommand(CGPoint(x: 3.0, y:4.0), type: .Line)
        ]
        
        XCTAssertEqual(actual, expect, "Should parse multiple line to calls with repeated numbers")
    }
    
    func testMultipleMoveToNewCommands() {
        let actual:[SVGCommand] = SVGPath("L1 2L3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 1.0, y:2.0), type: .Line),
            SVGCommand(CGPoint(x: 3.0, y:4.0), type: .Line)
        ]
        
        XCTAssertEqual(actual, expect, "Should parse multiple line to calls with new commands")
    }
    
    func testMultipleMoveToRelative() {
        let actual:[SVGCommand] = SVGPath("L1 2l1 2l5 6 1 1").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 1.0, y:2.0), type: .Line),
            SVGCommand(CGPoint(x: 2.0, y:4.0), type: .Line),
            SVGCommand(CGPoint(x: 7.0, y:10.0), type: .Line),
            SVGCommand(CGPoint(x: 8.0, y:11.0), type: .Line)
        ]
        
        XCTAssertEqual(actual, expect, "Should parse relative line to calls")
    }
}
