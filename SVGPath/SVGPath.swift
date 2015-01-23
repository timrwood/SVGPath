//
//  SVGPath.swift
//  SVGPath
//
//  Created by Tim Wood on 1/21/15.
//  Copyright (c) 2015 Tim Wood. All rights reserved.
//

import Foundation
import CoreGraphics

public class SVGPath {
    public var commands: [SVGCommand] = []
    var builder: SVGCommandBuilder?
    var numbers = ""

    public init (_ string: String) {
        for char in string {
            switch char {
            case "M": switchBuilder(singlePointBuilder(SVGCommand.Kind.Move, true))
            case "m": switchBuilder(singlePointBuilder(SVGCommand.Kind.Move, false))
            default: numbers.append(char)
            }
        }
        finishLastCommand()
    }
    
    private func switchBuilder (builder: SVGCommandBuilder) {
        finishLastCommand()
        self.builder = builder
    }
    
    private func finishLastCommand () {
        if let lastBuilder = builder {
            commands += lastBuilder(numbers: SVGPath.parseNumbers(numbers), last: commands.last)
        }
        numbers = ""
    }
}

// MARK: Numbers

private let numberSet = NSCharacterSet(charactersInString: "-.0123456789eE")
private let numberFormatter = NSNumberFormatter()

public extension SVGPath {
    class func parseNumbers (numbers: String) -> [Float] {
        var all:[String] = []
        var curr = ""
        var last = ""
        
        for char in numbers.unicodeScalars {
            var next = String(char)
            if next == "-" && last != "" && last != "E" && last != "e" {
                all.append(curr)
                curr = next
            } else if numberSet.longCharacterIsMember(char.value) {
                curr += next
            } else if curr.utf16Count > 0 {
                all.append(curr)
                curr = ""
            }
            last = next
        }
        
        all.append(curr)
        
        return all.map() {
            (number: String) -> Float in
            if let num = numberFormatter.numberFromString(number)?.floatValue {
                return num
            }
            return 0.0
        }
    }
}

// MARK: Commands

public struct SVGCommand: Equatable {
    public var point:CGPoint
    public var control1:CGPoint
    public var control2:CGPoint
    public var type:SVGCommand.Kind
    
    public enum Kind {
        case Move
        case Line
        case CubicCurve
    }
    
    public init (_ point: CGPoint, type: SVGCommand.Kind) {
        self.point = point
        self.control1 = point
        self.control2 = point
        self.type = type
    }
}

public func == (lhs: SVGCommand, rhs: SVGCommand) -> Bool {
    return lhs.point == rhs.point && lhs.control1 == rhs.control1 && lhs.control2 == rhs.control2
}

typealias SVGCommandBuilder = (numbers: [Float], last: SVGCommand?) -> [SVGCommand]

func pointAtIndex (array: [Float], index: Int) -> CGPoint {
    return CGPoint(x: Double(array[index]), y: Double(array[index + 1]))
}

// MARK: MoveTo

func singlePointBuilder (type: SVGCommand.Kind, absolute: Bool) -> SVGCommandBuilder {
    func builder(numbers: [Float], last: SVGCommand?) -> [SVGCommand] {
        var out: [SVGCommand] = []
        var lastCommand = last
        
        let count = (numbers.count / 2) * 2
        
        for var i = 0; i < count; i += 2 {
            var point = pointAtIndex(numbers, i)
            
            if !absolute {
                if let last = lastCommand {
                    point.x += last.point.x
                    point.y += last.point.y
                }
            }
            
            var command = SVGCommand(point, type: type)
            out.append(command)
            lastCommand = command
        }
        return out
    }
    return builder
}












