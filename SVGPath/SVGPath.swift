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

// MARK: Class

public class SVGPath {
    public var commands: [SVGCommand] = []
    private var builder: SVGCommandBuilder = moveTo
    private var coords: Coordinates = .Absolute
    private var stride: Int = 2
    private var numbers = ""

    public init (_ string: String) {
        for char in string {
            switch char {
            case "M": use(.Absolute, 2, moveTo)
            case "m": use(.Relative, 2, moveTo)
            case "L": use(.Absolute, 2, lineTo)
            case "l": use(.Relative, 2, lineTo)
            case "V": use(.Absolute, 1, lineToVertical)
            case "v": use(.Relative, 1, lineToVertical)
            case "H": use(.Absolute, 1, lineToHorizontal)
            case "h": use(.Relative, 1, lineToHorizontal)
            case "Q": use(.Absolute, 4, quadBroken)
            case "q": use(.Relative, 4, quadBroken)
            case "T": use(.Absolute, 2, quadSmooth)
            case "t": use(.Relative, 2, quadSmooth)
            case "C": use(.Absolute, 6, cubeBroken)
            case "c": use(.Relative, 6, cubeBroken)
            case "S": use(.Absolute, 4, cubeSmooth)
            case "s": use(.Relative, 4, cubeSmooth)
            default: numbers.append(char)
            }
        }
        finishLastCommand()
    }
    
    private func use (coords: Coordinates, _ stride: Int, _ builder: SVGCommandBuilder) {
        finishLastCommand()
        self.builder = builder
        self.coords = coords
        self.stride = stride
    }
    
    private func finishLastCommand () {
        for command in take(SVGPath.parseNumbers(numbers), stride, coords, commands.last, builder) {
            commands.append(coords == .Relative ? command.relativeTo(commands.last) : command)
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
        case CubeCurve
        case QuadCurve
    }
    
    public init (_ x: CGFloat, _ y: CGFloat, type: Kind) {
        let point = CGPoint(x: x, y: y)
        self.init(point, point, point, type: type)
    }
    
    public init (_ cx: CGFloat, _ cy: CGFloat, _ x: CGFloat, _ y: CGFloat) {
        let control = CGPoint(x: cx, y: cy)
        self.init(control, control, CGPoint(x: x, y: y), type: .QuadCurve)
    }
    
    public init (_ cx1: CGFloat, _ cy1: CGFloat, _ cx2: CGFloat, _ cy2: CGFloat, _ x: CGFloat, _ y: CGFloat) {
        self.init(CGPoint(x: cx1, y: cy1), CGPoint(x: cx2, y: cy2), CGPoint(x: x, y: y), type: .CubeCurve)
    }
    
    public init (_ control1: CGPoint, _ control2: CGPoint, _ point: CGPoint, type: Kind) {
        self.point = point
        self.control1 = control1
        self.control2 = control2
        self.type = type
    }
    
    private func relativeTo (other:SVGCommand?) -> SVGCommand {
        if let otherPoint = other?.point {
            return SVGCommand(control1 + otherPoint, control2 + otherPoint, point + otherPoint, type: type)
        }
        return self
    }
}

// MARK: CGPoint helpers

private func +(a:CGPoint, b:CGPoint) -> CGPoint {
    return CGPoint(x: a.x + b.x, y: a.y + b.y)
}

private func -(a:CGPoint, b:CGPoint) -> CGPoint {
    return CGPoint(x: a.x - b.x, y: a.y - b.y)
}

// MARK: Command Builders

private typealias SVGCommandBuilder = (Slice<CGFloat>, SVGCommand?, Coordinates) -> SVGCommand

private func take (numbers: [CGFloat], stride: Int, coords: Coordinates, last: SVGCommand?, callback: SVGCommandBuilder) -> [SVGCommand] {
    var out: [SVGCommand] = []
    var lastCommand:SVGCommand? = last

    let count = (numbers.count / stride) * stride
    
    for var i = 0; i < count; i += stride {
        let nums = numbers[i..<i + stride]
        lastCommand = callback(nums, lastCommand, coords)
        out.append(lastCommand!)
    }
    
    return out
}

// MARK: Mm - Move

private func moveTo (numbers: Slice<CGFloat>, last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], type: .Move)
}

// MARK: Ll - Line

private func lineTo (numbers: Slice<CGFloat>, last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], type: .Line)
}

// MARK: Vv - Vertical Line

private func lineToVertical (numbers: Slice<CGFloat>, last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(coords == .Absolute ? last?.point.x ?? 0 : 0, numbers[0], type: .Line)
}

// MARK: Hh - Horizontal Line

private func lineToHorizontal (numbers: Slice<CGFloat>, last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], coords == .Absolute ? last?.point.y ?? 0 : 0, type: .Line)
}

// MARK: Qq - Quadratic Curve To

private func quadBroken (numbers: Slice<CGFloat>, last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], numbers[2], numbers[3])
}

// MARK: Tt - Smooth Quadratic Curve To

private func quadSmooth (numbers: Slice<CGFloat>, last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    let lastControl = last?.control1 ?? CGPoint()
    let lastPoint = last?.point ?? CGPoint()
    var control = lastPoint - lastControl
    if coords == .Absolute {
        control = control + lastPoint
    }
    return SVGCommand(control.x, control.y, numbers[0], numbers[1])
}

// MARK: Cc - Cubic Curve To

private func cubeBroken (numbers: Slice<CGFloat>, last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], numbers[2], numbers[3], numbers[4], numbers[5])
}

// MARK: Ss - Smooth Cubic Curve To

private func cubeSmooth (numbers: Slice<CGFloat>, last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    var lastControl = last?.control2 ?? CGPoint()
    let lastPoint = last?.point ?? CGPoint()
    if (last?.type ?? .Line) != .CubeCurve {
        lastControl = lastPoint
    }
    var control = lastPoint - lastControl
    if coords == .Absolute {
        control = control + lastPoint
    }
    return SVGCommand(control.x, control.y, numbers[0], numbers[1], numbers[2], numbers[3])
}
