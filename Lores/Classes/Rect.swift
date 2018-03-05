//
//  Rect.swift
//  Lores
//
//  Created by Wolf McNally on 3/3/18.
//

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

    public func randomX() -> Int { return origin.x + size.randomX() }
    public func randomY() -> Int { return origin.y + size.randomY() }
    public func randomPoint() -> Point { return Point(x: randomX(), y: randomY()) }
}
