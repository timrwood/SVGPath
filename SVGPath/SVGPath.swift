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
    func builder(numbers: [Float], last: SVGCommand?) -> [SVGCommand] {
        var out: [SVGCommand] = []
        var lastCommand = last
        
        let count = (numbers.count / 2) * 2
        
        for var i = 0; i < count; i += 2 {
            var point = pointAtIndex(numbers, i)
            
            if coords == .Relative {
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

private func scalar (direction: Direction, coords: Coordinates) -> SVGCommandBuilder {
    func builder(numbers: [Float], last: SVGCommand?) -> [SVGCommand] {
        var out: [SVGCommand] = []
        var lastCommand = last
        
        for var i = 0; i < numbers.count; i++ {
            var point:CGPoint = CGPoint()
            
            if let last = lastCommand {
                point = last.point
            }

            if coords == .Absolute {
                if direction == .Vertical {
                    point.y = CGFloat(numbers[i])
                } else {
                    point.x = CGFloat(numbers[i])
                }
            } else {
                if direction == .Vertical {
                    point.y += CGFloat(numbers[i])
                } else {
                    point.x += CGFloat(numbers[i])
                }
            }
            
            var command = SVGCommand(point, type: .Line)
            out.append(command)
            lastCommand = command
        }
        return out
    }
    return builder
}

private func quad (continuation: Continuation, coords: Coordinates) -> SVGCommandBuilder {
    func builder(numbers: [Float], last: SVGCommand?) -> [SVGCommand] {
        var out: [SVGCommand] = []
        var lastCommand = last
        
        let step = continuation == .Smooth ? 2 : 4
        let count = (numbers.count / step) * step
        
        for var i = 0; i < count; i += step {
            var point = pointAtIndex(numbers, i)
            var control = pointAtIndex(numbers, i + 2)
            
            if coords == .Relative {
                if let last = lastCommand {
                    point.x += last.point.x
                    point.y += last.point.y
                }
            }
            
            var command = SVGCommand(point, control, type: .QuadCurve)
            out.append(command)
            lastCommand = command
        }
        return out
    }
    return builder
}







