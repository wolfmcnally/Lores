//
//  WolfCoreBridge.swift
//  Lores
//
//  Created by 🐺 McNally on 3/4/18.
//

import WolfCore

public typealias DPoint = WolfCore.Point
public typealias Vector = WolfCore.Vector
public typealias Frac = WolfCore.Frac
public typealias Interval = WolfCore.Interval
public typealias Random = WolfCore.Random
public typealias Color = WolfCore.Color

extension DPoint {
    public var point: Point {
        return Point(x: Int(x), y: Int(y))
    }
}

// Because we can't selectively import operators from WolfCore, and we want Lores users to be able to gain some of the advantages of WolfCore without importing it directly.

public func - (lhs: DPoint, rhs: DPoint) -> Vector {
    return Vector(dx: rhs.x - lhs.x, dy: rhs.y - lhs.y)
}

public func + (lhs: DPoint, rhs: Vector) -> DPoint {
    return DPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}

public func += (lhs: inout DPoint, rhs: Vector) {
    lhs = lhs + rhs
}

public func - (lhs: DPoint, rhs: Vector) -> DPoint {
    return DPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
}

public func -= (lhs: inout DPoint, rhs: Vector) {
    lhs = lhs - rhs
}

public func + (lhs: Vector, rhs: DPoint) -> DPoint {
    return DPoint(x: lhs.dx + rhs.x, y: lhs.dy + rhs.y)
}

public func - (lhs: Vector, rhs: DPoint) -> DPoint {
    return DPoint(x: lhs.dx - rhs.x, y: lhs.dy - rhs.y)
}

/// Interval-Creation Operator
infix operator .. : RangeFormationPrecedence
public func .. <T>(left: T, right: T) -> Interval<T> {
    return Interval(left, right)
}

/// Degrees-To-Radians-Operator
import func WolfCore.radians
postfix operator °
public postfix func °<T: BinaryFloatingPoint>(rhs: T) -> T {
    return radians(for: rhs)
}

