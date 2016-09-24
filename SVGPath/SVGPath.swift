//
//  SVGPath.swift
//  SVGPath
//
//  Created by Tim Wood on 1/21/15.
//  Copyright (c) 2015 Tim Wood. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: UIBezierPath

public extension UIBezierPath {
    convenience init (svgPath: String) {
        self.init()
        applyCommands(svgPath, path: self)
    }
}

private func applyCommands (_ svgPath: String, path: UIBezierPath) {
    for command in SVGPath(svgPath).commands {
        switch command.type {
        case .move: path.move(to: command.point)
        case .line: path.addLine(to: command.point)
        case .quadCurve: path.addQuadCurve(to: command.point, controlPoint: command.control1)
        case .cubeCurve: path.addCurve(to: command.point, controlPoint1: command.control1, controlPoint2: command.control2)
        case .close: path.close()
        }
    }
}

// MARK: Enums

private enum Coordinates {
    case absolute
    case relative
}

// MARK: Class

open class SVGPath {
    open var commands: [SVGCommand] = []
    fileprivate var builder: SVGCommandBuilder = moveTo
    fileprivate var coords: Coordinates = .absolute
    fileprivate var stride: Int = 2
    fileprivate var numbers = ""

    public init (_ string: String) {
        for char in string.characters {
            switch char {
            case "M": use(.absolute, 2, moveTo)
            case "m": use(.relative, 2, moveTo)
            case "L": use(.absolute, 2, lineTo)
            case "l": use(.relative, 2, lineTo)
            case "V": use(.absolute, 1, lineToVertical)
            case "v": use(.relative, 1, lineToVertical)
            case "H": use(.absolute, 1, lineToHorizontal)
            case "h": use(.relative, 1, lineToHorizontal)
            case "Q": use(.absolute, 4, quadBroken)
            case "q": use(.relative, 4, quadBroken)
            case "T": use(.absolute, 2, quadSmooth)
            case "t": use(.relative, 2, quadSmooth)
            case "C": use(.absolute, 6, cubeBroken)
            case "c": use(.relative, 6, cubeBroken)
            case "S": use(.absolute, 4, cubeSmooth)
            case "s": use(.relative, 4, cubeSmooth)
            case "Z": use(.absolute, 1, close)
            case "z": use(.absolute, 1, close)
            default: numbers.append(char)
            }
        }
        finishLastCommand()
    }

    fileprivate func use (_ coords: Coordinates, _ stride: Int, _ builder: @escaping SVGCommandBuilder) {
        finishLastCommand()
        self.builder = builder
        self.coords = coords
        self.stride = stride
    }
    
    fileprivate func finishLastCommand () {
        for command in take(SVGPath.parseNumbers(numbers), strideAmount: stride, coords: coords, last: commands.last, callback: builder) {
            commands.append(coords == .relative ? command.relativeTo(commands.last) : command)
        }
        numbers = ""
    }
}

// MARK: Numbers

private let numberSet = CharacterSet(charactersIn: "-.0123456789eE")
private let locale = Locale(identifier: "en_US")


public extension SVGPath {
    class func parseNumbers (_ numbers: String) -> [CGFloat] {
        var all:[String] = []
        var curr = ""
        var last = ""
        
        for char in numbers.unicodeScalars {
            let next = String(char)
            if next == "-" && last != "" && last != "E" && last != "e" {
                if curr.utf16.count > 0 {
                    all.append(curr)
                }
                curr = next
            } else if numberSet.contains(UnicodeScalar(char.value)!) {
                curr += next
            } else if curr.utf16.count > 0 {
                all.append(curr)
                curr = ""
            }
            last = next
        }
        
        all.append(curr)
        
        return all.map { CGFloat(NSDecimalNumber(string: $0, locale: locale)) }
    }
}

// MARK: Commands

public struct SVGCommand {
    public var point:CGPoint
    public var control1:CGPoint
    public var control2:CGPoint
    public var type:Kind
    
    public enum Kind {
        case move
        case line
        case cubeCurve
        case quadCurve
        case close
    }
    
    public init () {
        let point = CGPoint()
        self.init(point, point, point, type: .close)
    }
    
    public init (_ x: CGFloat, _ y: CGFloat, type: Kind) {
        let point = CGPoint(x: x, y: y)
        self.init(point, point, point, type: type)
    }
    
    public init (_ cx: CGFloat, _ cy: CGFloat, _ x: CGFloat, _ y: CGFloat) {
        let control = CGPoint(x: cx, y: cy)
        self.init(control, control, CGPoint(x: x, y: y), type: .quadCurve)
    }
    
    public init (_ cx1: CGFloat, _ cy1: CGFloat, _ cx2: CGFloat, _ cy2: CGFloat, _ x: CGFloat, _ y: CGFloat) {
        self.init(CGPoint(x: cx1, y: cy1), CGPoint(x: cx2, y: cy2), CGPoint(x: x, y: y), type: .cubeCurve)
    }
    
    public init (_ control1: CGPoint, _ control2: CGPoint, _ point: CGPoint, type: Kind) {
        self.point = point
        self.control1 = control1
        self.control2 = control2
        self.type = type
    }
    
    fileprivate func relativeTo (_ other:SVGCommand?) -> SVGCommand {
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

private typealias SVGCommandBuilder = ([CGFloat], SVGCommand?, Coordinates) -> SVGCommand

private func take (_ numbers: [CGFloat], strideAmount: Int, coords: Coordinates, last: SVGCommand?, callback: SVGCommandBuilder) -> [SVGCommand] {
    var out: [SVGCommand] = []
    var lastCommand:SVGCommand? = last

    let count = (numbers.count / strideAmount) * strideAmount
    var nums:[CGFloat] = [0, 0, 0, 0, 0, 0];

    for i in stride(from: 0, to: count, by: strideAmount) {
        for j in 0 ..< strideAmount {
            nums[j] = numbers[i + j]
        }
        lastCommand = callback(nums, lastCommand, coords)
        out.append(lastCommand!)
    }
    
    return out
}

// MARK: Mm - Move

private func moveTo (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], type: .move)
}

// MARK: Ll - Line

private func lineTo (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], type: .line)
}

// MARK: Vv - Vertical Line

private func lineToVertical (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(coords == .absolute ? last?.point.x ?? 0 : 0, numbers[0], type: .line)
}

// MARK: Hh - Horizontal Line

private func lineToHorizontal (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], coords == .absolute ? last?.point.y ?? 0 : 0, type: .line)
}

// MARK: Qq - Quadratic Curve To

private func quadBroken (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], numbers[2], numbers[3])
}

// MARK: Tt - Smooth Quadratic Curve To

private func quadSmooth (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    var lastControl = last?.control1 ?? CGPoint()
    let lastPoint = last?.point ?? CGPoint()
    if (last?.type ?? .line) != .quadCurve {
        lastControl = lastPoint
    }
    var control = lastPoint - lastControl
    if coords == .absolute {
        control = control + lastPoint
    }
    return SVGCommand(control.x, control.y, numbers[0], numbers[1])
}

// MARK: Cc - Cubic Curve To

private func cubeBroken (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand(numbers[0], numbers[1], numbers[2], numbers[3], numbers[4], numbers[5])
}

// MARK: Ss - Smooth Cubic Curve To

private func cubeSmooth (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    var lastControl = last?.control2 ?? CGPoint()
    let lastPoint = last?.point ?? CGPoint()
    if (last?.type ?? .line) != .cubeCurve {
        lastControl = lastPoint
    }
    var control = lastPoint - lastControl
    if coords == .absolute {
        control = control + lastPoint
    }
    return SVGCommand(control.x, control.y, numbers[0], numbers[1], numbers[2], numbers[3])
}

// MARK: Zz - Close Path

private func close (_ numbers: [CGFloat], last: SVGCommand?, coords: Coordinates) -> SVGCommand {
    return SVGCommand()
}
