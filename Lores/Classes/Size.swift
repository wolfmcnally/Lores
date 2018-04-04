//
//  Size.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

import WolfCore

public struct Size {
    public var width: Int
    public var height: Int

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    public func randomX() -> Int {
        return Random.number(0 ..< width)
    }

    public func randomY() -> Int {
        return Random.number(0 ..< height)
    }

    public func randomPoint() -> Point {
        return Point(x: randomX(), y: randomY())
    }

    public static let zero = Size(width: 0, height: 0)

    public var bounds: Rect {
        return Rect(origin: .zero, size: self)
    }

    public var aspect: CGFloat {
        return CGFloat(width) / CGFloat(height)
    }
}

extension Size: CustomStringConvertible {
    public var description: String {
        get {
            return "Size(width:\(width) height:\(height))"
        }
    }
}
