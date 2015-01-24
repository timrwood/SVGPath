//
//  SVGPath.swift
//  SVGPath
//
//  Created by Tim Wood on 1/21/15.
//  Copyright (c) 2015 Tim Wood. All rights reserved.
//

import Foundation
import CoreGraphics


// MARK: Enums

private enum Coordinates {
    case Absolute
    case Relative
}

private enum Direction {
    case Vertical
    case Horizontal
}

private enum Continuation {
    case Smooth
    case Broken
}

// MARK: Class

public class SVGPath {
    public var commands: [SVGCommand] = []
    var builder: SVGCommandBuilder?
    var numbers = ""

    public init (_ string: String) {
        for char in string {
            switch char {
            case "M": use(vector(.Move, .Absolute))
            case "m": use(vector(.Move, .Relative))
            case "L": use(vector(.Line, .Absolute))
            case "l": use(vector(.Line, .Relative))
            case "V": use(scalar(.Vertical, .Absolute))
            case "v": use(scalar(.Vertical, .Relative))
            case "H": use(scalar(.Horizontal, .Absolute))
            case "h": use(scalar(.Horizontal, .Relative))
            case "Q": use(quad(.Broken, .Absolute))
            case "q": use(quad(.Broken, .Relative))
            default: numbers.append(char)
            }
        }
        finishLastCommand()
    }
    
    private func use (builder: SVGCommandBuilder) {
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
    public var type:Kind
    
    public enum Kind {
        case Move
        case Line
        case Curve
        case QuadCurve
    }
    
    public init (_ point: CGPoint, type: Kind) {
        self.point = point
        self.control1 = point
        self.control2 = point
        self.type = type
    }
    
    public init (_ point: CGPoint, _ control: CGPoint, type: Kind) {
        self.point = point
        self.control1 = control
        self.control2 = control
        self.type = type
    }
    
    private mutating func relativeTo (other:SVGCommand?, coords: Coordinates) -> SVGCommand {
        if coords == .Absolute { return self }
        if let otherPoint = other?.point {
            point.x += otherPoint.x
            point.y += otherPoint.y
            control1.x += otherPoint.x
            control1.y += otherPoint.y
            control2.x += otherPoint.x
            control2.y += otherPoint.y
        }
        return self
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

private func vector (type: SVGCommand.Kind, coords: Coordinates) -> SVGCommandBuilder {
    func builder(numbers: [Float], lastCommand: SVGCommand?) -> [SVGCommand] {
        var out: [SVGCommand] = []
        var last = lastCommand
        
        let count = (numbers.count / 2) * 2
        
        for var i = 0; i < count; i += 2 {
            var command = SVGCommand(pointAtIndex(numbers, i), type: type)
            last = command.relativeTo(last, coords: coords)
            out.append(command)
        }

        return out
    }
    return builder
}

private func scalar (direction: Direction, coords: Coordinates) -> SVGCommandBuilder {
    func builder(numbers: [Float], lastCommand: SVGCommand?) -> [SVGCommand] {
        var out: [SVGCommand] = []
        var last = lastCommand
        
        for var i = 0; i < numbers.count; i++ {
            var point:CGPoint = CGPoint()
            let num = CGFloat(numbers[i])
            
            if let lastPoint = last?.point {
                point = lastPoint
            }
            
            if coords == .Absolute {
                if direction == .Vertical {
                    point.y = num
                } else {
                    point.x = num
                }
            } else {
                if direction == .Vertical {
                    point.y += num
                } else {
                    point.x += num
                }
            }
            
            last = SVGCommand(point, type: .Line)
            out.append(last!)
        }
        return out
    }
    return builder
}

private func quad (continuation: Continuation, coords: Coordinates) -> SVGCommandBuilder {
    func builder(numbers: [Float], lastCommand: SVGCommand?) -> [SVGCommand] {
        var out: [SVGCommand] = []
        var last = lastCommand
        
        let step = continuation == .Smooth ? 2 : 4
        let count = (numbers.count / step) * step
        
        for var i = 0; i < count; i += step {
            var command = SVGCommand(pointAtIndex(numbers, i + 2), pointAtIndex(numbers, i), type: .QuadCurve)
            last = command.relativeTo(last, coords: coords)
            out.append(command)
        }
        return out
    }
    return builder
}
