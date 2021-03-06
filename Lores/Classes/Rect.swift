//
//  Rect.swift
//  Lores
//
//  Created by Wolf McNally on 3/3/18.
//

import Foundation

public struct Rect {
    public var origin: Point
    public var size: Size

    public var width: Int { return size.width }
    public var height: Int { return size.height }

    public var min: Point { return origin }
    public var max: Point { return Point(x: maxX, y: maxY) }
    public var mid: Point { return Point(x: midX, y: midY) }

    public var minX: Int { return origin.x }
    public var minY: Int { return origin.y }

    public var maxX: Int { return origin.x + size.width - 1 }
    public var maxY: Int { return origin.y + size.height - 1 }

    public var midX: Int { return origin.x + size.width / 2 }
    public var midY: Int { return origin.y + size.height / 2 }

    public var rangeX: CountableClosedRange<Int> { return minX ... maxX }
    public var rangeY: CountableClosedRange<Int> { return minY ... maxY }

    public func randomX() -> Int { return origin.x + size.randomX() }
    public func randomY() -> Int { return origin.y + size.randomY() }
    public func randomPoint() -> Point { return Point(x: randomX(), y: randomY()) }

    public func isValidPoint(_ p: Point) -> Bool {
        return p.x >= minX && p.y >= minY && p.x <= maxX && p.y <= maxY
    }

    public func checkPoint(_ point: Point) {
        assert(point.x >= minX, "x must be >= \(minX)")
        assert(point.y >= minY, "y must be >= \(minY)")
        assert(point.x <= maxX, "x must be <= \(maxX)")
        assert(point.y <= maxY, "y must be <= \(maxY)")
    }
}
