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
            commands += lastBuilder(SVGPath.parseNumbers(numbers), commands.last)
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

typealias SVGCommandBuilder = ([Float], SVGCommand?) -> [SVGCommand]

func pointAtIndex (array: [Float], index: Int) -> CGPoint {
    return CGPoint(x: Double(array[index]), y: Double(array[index + 1]))
}

private func point (x:Float, y:Float) -> CGPoint {
    return CGPoint(x: CGFloat(x), y: CGFloat(y))
}

private func take (numbers: [Float], stride: Int, last: SVGCommand?, coords:Coordinates, callback: (Slice<Float>, SVGCommand?) -> SVGCommand) -> [SVGCommand] {
    var out: [SVGCommand] = []
    var lastCommand:SVGCommand? = last

    let count = (numbers.count / stride) * stride
    
    for var i = 0; i < count; i += stride {
        let nums = numbers[i..<i + stride]
        var command = callback(nums, lastCommand)
        lastCommand = command.relativeTo(lastCommand, coords: coords)
        out.append(lastCommand!)
    }
    
    return out
}

private func vector (type: SVGCommand.Kind, coords: Coordinates) -> SVGCommandBuilder {
    func build (numbers: [Float], lastCommand: SVGCommand?) -> [SVGCommand] {
        return take(numbers, 2, lastCommand, coords) {
            (nums:Slice<Float>, last: SVGCommand?) -> SVGCommand in
            return SVGCommand(point(nums[0], nums[1]), type: type)
        }
    }
    return build
}

private func scalar (direction: Direction, coords: Coordinates) -> SVGCommandBuilder {
    func build (numbers: [Float], lastCommand: SVGCommand?) -> [SVGCommand] {
        return take(numbers, 1, lastCommand, .Absolute) {
            (nums:Slice<Float>, last: SVGCommand?) -> SVGCommand in

            var point:CGPoint = CGPoint()
            let num = CGFloat(nums[0])
            
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
            
            return SVGCommand(point, type: .Line)
        }
    }
    return build
}

private func quad (continuation: Continuation, coords: Coordinates) -> SVGCommandBuilder {
    func build (numbers: [Float], lastCommand: SVGCommand?) -> [SVGCommand] {
        return take(numbers, continuation == .Smooth ? 2 : 4, lastCommand, coords) {
            (nums:Slice<Float>, last: SVGCommand?) -> SVGCommand in
            return SVGCommand(point(nums[2], nums[3]), point(nums[0], nums[1]), type: .QuadCurve)
        }
    }
    return build
}
