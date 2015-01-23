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
            SVGCommand(CGPoint(x: 1.0, y:2.0), type: .Move)
        ]
        
        XCTAssertEqual(actual, expect, "Should parse a single move to call")
    }
    
    func testMultipleMoveTo() {
        let actual:[SVGCommand] = SVGPath("M1 2 3 4").commands
        let expect:[SVGCommand] = [
            SVGCommand(CGPoint(x: 1.0, y:2.0), type: .Move),
            SVGCommand(CGPoint(x: 3.0, y:4.0), type: .Move)
        ]
        
        XCTAssertEqual(actual, expect, "Should parse multiple move to calls")
    }
}
