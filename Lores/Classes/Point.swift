//
//  Point.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

public struct Point {
    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public static let zero = Point(x: 0, y: 0)
}

extension Point {
    public var dpoint: DPoint {
        return DPoint(x: Double(x), y: Double(y))
    }
}

public func + (lhs: Point, rhs: Offset) -> Point {
    return Point(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}

public func += (lhs: inout Point, rhs: Offset) {
    lhs = lhs + rhs
}

extension Point: CustomStringConvertible {
    public var description: String {
        get {
            return "Point(x:\(x) y:\(y))"
        }
    }
}
