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
    private var builder: SVGCommandBuilder?
    private var coords: Coordinates = .Absolute
    private var numbers = ""

    public init (_ string: String) {
        for char in string {
            switch char {
            case "M": use(vector(.Move), .Absolute)
            case "m": use(vector(.Move), .Relative)
            case "L": use(vector(.Line), .Absolute)
            case "l": use(vector(.Line), .Relative)
            case "V": use(scalar(.Vertical), .Absolute)
            case "v": use(scalar(.Vertical), .Relative)
            case "H": use(scalar(.Horizontal), .Absolute)
            case "h": use(scalar(.Horizontal), .Relative)
            case "Q": use(quadBroken, .Absolute)
            case "q": use(quadBroken, .Relative)
            case "T": use(quadSmooth, .Absolute)
            case "t": use(quadSmooth, .Relative)
            default: numbers.append(char)
            }
        }
        finishLastCommand()
    }
    
    private func use (builder: SVGCommandBuilder, _ coords: Coordinates) {
        finishLastCommand()
        self.builder = builder
        self.coords = coords
    }
    
    private func finishLastCommand () {
        if let buildCommands = builder {
            for command in buildCommands(SVGPath.parseNumbers(numbers), commands.last, coords) {
                var c = command
                c.relativeTo(commands.last, coords: coords)
                commands.append(c)
            }
        }
        numbers = ""
    }
}

// MARK: Numbers

private let numberSet = NSCharacterSet(charactersInString: "-.0123456789eE")
private let numberFormatter = NSNumberFormatter()

public extension SVGPath {
    class func parseNumbers (numbers: String) -> [CGFloat] {
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
            (number: String) -> CGFloat in
            if let num = numberFormatter.numberFromString(number)?.doubleValue {
                return CGFloat(num)
            }
            return 0.0
        }
    }
}

// MARK: Commands

public struct SVGCommand {
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
        self.init(point, point, type: type)
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
            point = point + otherPoint
            control1 = control1 + otherPoint
            control2 = control2 + otherPoint
        }
        return self
    }
}

private typealias SVGCommandBuilder = ([CGFloat], SVGCommand?, Coordinates) -> [SVGCommand]

private func +(a:CGPoint, b:CGPoint) -> CGPoint {
    return CGPoint(x: a.x + b.x, y: a.y + b.y)
}

private func -(a:CGPoint, b:CGPoint) -> CGPoint {
    return CGPoint(x: a.x - b.x, y: a.y - b.y)
}

func pointAtIndex (slice: Slice<CGFloat>, index: Int) -> CGPoint {
    return CGPoint(x: slice[index], y: slice[index + 1])
}

private func take (numbers: [CGFloat], stride: Int, last: SVGCommand?, callback: (Slice<CGFloat>, SVGCommand?) -> SVGCommand) -> [SVGCommand] {
    var out: [SVGCommand] = []
    var lastCommand:SVGCommand? = last

    let count = (numbers.count / stride) * stride
    
    for var i = 0; i < count; i += stride {
        let nums = numbers[i..<i + stride]
        lastCommand = callback(nums, lastCommand)
        out.append(lastCommand!)
    }
    
    return out
}

private func vector (type: SVGCommand.Kind) -> SVGCommandBuilder {
    func build (numbers: [CGFloat], lastCommand: SVGCommand?, coords: Coordinates) -> [SVGCommand] {
        return take(numbers, 2, lastCommand) {
            (nums:Slice<CGFloat>, last: SVGCommand?) -> SVGCommand in
            return SVGCommand(pointAtIndex(nums, 0), type: type)
        }
    }
    return build
}

private func scalar (direction: Direction) -> SVGCommandBuilder {
    func build (numbers: [CGFloat], lastCommand: SVGCommand?, coords: Coordinates) -> [SVGCommand] {
        return take(numbers, 1, lastCommand) {
            (nums:Slice<CGFloat>, last: SVGCommand?) -> SVGCommand in

            var point:CGPoint = CGPoint()
            
            if coords == .Absolute {
                point = last?.point ?? point
            }
            
            if direction == .Vertical {
                point.y = nums[0]
            } else {
                point.x = nums[0]
            }
            
            return SVGCommand(point, type: .Line)
        }
    }
    return build
}

private func quadBroken (numbers: [CGFloat], lastCommand: SVGCommand?, coords: Coordinates) -> [SVGCommand] {
    return take(numbers, 4, lastCommand) {
        (nums:Slice<CGFloat>, last: SVGCommand?) -> SVGCommand in
        
        return SVGCommand(pointAtIndex(nums, 2), pointAtIndex(nums, 0), type: .QuadCurve)
    }
}

private func quadSmooth (numbers: [CGFloat], lastCommand: SVGCommand?, coords: Coordinates) -> [SVGCommand] {
    return take(numbers, 2, lastCommand) {
        (nums:Slice<CGFloat>, last: SVGCommand?) -> SVGCommand in
        let lastControl = last?.control1 ?? CGPoint()
        let lastPoint = last?.point ?? CGPoint()
        var control = lastPoint - lastControl
        if coords == .Absolute {
            control = control + lastPoint
        }
        return SVGCommand(pointAtIndex(nums, 0), control, type: .QuadCurve)
    }
}

