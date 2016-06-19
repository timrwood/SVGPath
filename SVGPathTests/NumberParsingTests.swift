//
//  SVGPathTests.swift
//  SVGPathTests
//
//  Created by Tim Wood on 1/21/15.
//  Copyright (c) 2015 Tim Wood. All rights reserved.
//

import XCTest
import SVGPath

class NumberParsingTests: XCTestCase {
    func testSpaceSeparatedInts() {
        let actual:[CGFloat] = SVGPath.parse("1 2 3 4")
        let expect:[CGFloat] = [1.0, 2.0, 3.0, 4.0]
        
        XCTAssertEqual(actual, expect, "Should parse space separated ints")
    }
    
    func testCommaSeparatedInts() {
        let actual:[CGFloat] = SVGPath.parse("1,2,3,4")
        let expect:[CGFloat] = [1.0, 2.0, 3.0, 4.0]
        
        XCTAssertEqual(actual, expect, "Should parse comma separated ints")
    }
    
    func testMinusSeparatedInts() {
        let actual:[CGFloat] = SVGPath.parse("-1-2-3-4")
        let expect:[CGFloat] = [-1.0, -2.0, -3.0, -4.0]
        
        XCTAssertEqual(actual, expect, "Should parse minus separated ints")
    }
    
    func testSpaceSeparatedFloats() {
        let actual:[CGFloat] = SVGPath.parse("1.5 2.6 3.7 4.8")
        let expect:[CGFloat] = [1.5, 2.6, 3.7, 4.8]
        
        XCTAssertEqual(actual, expect, "Should parse space separated floats")
    }
    
    func testCommaSeparatedFloats() {
        let actual:[CGFloat] = SVGPath.parse("1.5,2.6,3.7,4.8")
        let expect:[CGFloat] = [1.5, 2.6, 3.7, 4.8]
        
        XCTAssertEqual(actual, expect, "Should parse comma separated floats")
    }
    
    func testMinusSeparatedFloats() {
        let actual:[CGFloat] = SVGPath.parse("-1.5-2.6-3.7-4.8")
        let expect:[CGFloat] = [-1.5, -2.6, -3.7, -4.8]
        
        XCTAssertEqual(actual, expect, "Should parse minus separated floats")
    }
    
    func testSpaceSeparatedExponent() {
        let actual:[CGFloat] = SVGPath.parse("1e1 1e2 1E3 1E4")
        let expect:[CGFloat] = [10.0, 100.0, 1000.0, 10000.0]
        
        XCTAssertEqual(actual, expect, "Should use e or E for the exponent")
    }
    
    func testNonSeparatingExponent() {
        let actual:[CGFloat] = SVGPath.parse("1e-5-1e-5,1E-5-1E-5")
        let expect:[CGFloat] = [0.00001, -0.00001, 0.00001, -0.00001]
        
        XCTAssertEqual(actual, expect, "Should not split on the minus from an exponent")
    }
    
    func testNegativeNumbersFollowingSpaces() {
        let actual:[CGFloat] = SVGPath.parse("-2.1 1 -1 2.1 -1 3.4")
        let expect:[CGFloat] = [-2.1, 1, -1, 2.1, -1, 3.4]

        XCTAssertEqual(actual, expect, "Should allow spaces before negative numbers")
    }
}
