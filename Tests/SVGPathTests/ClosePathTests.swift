//
//  ClosePathTests.swift
//  SVGPath
//
//  Created by Tim Wood on 1/26/15.
//  Copyright (c) 2015 Tim Wood. All rights reserved.
//

import XCTest
import SVGPath

class ClosePathTests: XCTestCase {
    func testAbsoluteCloseAfterMoveTo() {
        let actual: [SVGCommand] = SVGPath("M1 2Z").commands
        let expect: [SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .move),
            SVGCommand()
        ]

        assertCommandsEqual(actual, expect)
    }

    func testRelativeCloseAfterMoveTo() {
        let actual: [SVGCommand] = SVGPath("M1 2z").commands
        let expect: [SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .move),
            SVGCommand()
        ]

        assertCommandsEqual(actual, expect)
    }

    func testAbsoluteCloseAfterLineTo() {
        let actual: [SVGCommand] = SVGPath("L1 2Z").commands
        let expect: [SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .line),
            SVGCommand()
        ]

        assertCommandsEqual(actual, expect)
    }

    func testRelativeCloseAfterLineTo() {
        let actual: [SVGCommand] = SVGPath("L1 2z").commands
        let expect: [SVGCommand] = [
            SVGCommand(1.0, 2.0, type: .line),
            SVGCommand()
        ]

        assertCommandsEqual(actual, expect)
    }

    func testAbsoluteCloseAfterQuadraticCurveTo() {
        let actual: [SVGCommand] = SVGPath("Q1 2 3 4Z").commands
        let expect: [SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0, 4.0),
            SVGCommand()
        ]

        assertCommandsEqual(actual, expect)
    }

    func testRelativeCloseAfterQuadraticCurveTo() {
        let actual: [SVGCommand] = SVGPath("Q1 2 3 4z").commands
        let expect: [SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0, 4.0),
            SVGCommand()
        ]

        assertCommandsEqual(actual, expect)
    }

    func testAbsoluteCloseAfterCubicCurveTo() {
        let actual: [SVGCommand] = SVGPath("C1 2 3 4 5 6Z").commands
        let expect: [SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0),
            SVGCommand()
        ]

        assertCommandsEqual(actual, expect)
    }

    func testRelativeCloseAfterCubicCurveTo() {
        let actual: [SVGCommand] = SVGPath("C1 2 3 4 5 6z").commands
        let expect: [SVGCommand] = [
            SVGCommand(1.0, 2.0, 3.0, 4.0, 5.0, 6.0),
            SVGCommand()
        ]

        assertCommandsEqual(actual, expect)
    }
}
