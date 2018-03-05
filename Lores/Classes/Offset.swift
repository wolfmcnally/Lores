//
//  Offset.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

import WolfCore

public struct Offset {
    public var dx: Int
    public var dy: Int

    public init(dx: Int, dy: Int) {
        self.dx = dx
        self.dy = dy
    }

    public static let zero = Offset(dx: 0, dy: 0)

    public static let up = Offset(dx: 0, dy: -1)
    public static let left = Offset(dx: -1, dy: 0)
    public static let down = Offset(dx: 0, dy: 1)
    public static let right = Offset(dx: 1, dy: 0)
}

extension Offset: Equatable {
    public static func == (lhs: Offset, rhs: Offset) -> Bool {
        return lhs.dx == rhs.dx && lhs.dy == rhs.dy
    }
}

extension Offset: CustomStringConvertible {
    public var description: String {
        get {
            return "Offset(dx:\(dx) dy:\(dy))"
        }
    }
}
