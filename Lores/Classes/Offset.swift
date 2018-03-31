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

public func + (lhs: Offset, rhs: Offset) -> Offset {
    return Offset(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

public func += (lhs: inout Offset, rhs: Offset) {
    lhs = lhs + rhs
}

extension Offset: CustomStringConvertible {
    public var description: String {
        get {
            return "Offset(dx:\(dx) dy:\(dy))"
        }
    }
}

public enum Heading {
    case up
    case left
    case down
    case right

    public var offset: Offset {
        switch self {
        case .up: return .up
        case .left: return .left
        case .down: return .down
        case .right: return .right
        }
    }

    public var nextClockwise: Heading {
        switch self {
        case .up: return .right
        case .left: return .up
        case .down: return .left
        case .right: return .down
        }
    }

    public var nextCounterClockwise: Heading {
        switch self {
        case .up: return .left
        case .left: return .down
        case .down: return .right
        case .right: return .up
        }
    }
}
