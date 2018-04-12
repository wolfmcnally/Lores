//
//  Direction.swift
//  Pods
//
//  Created by Wolf McNally on 4/7/18.
//

public enum Direction {
    case up
    case left
    case down
    case right

    public var offset: Offset {
        switch self {
        case .up:
            return Offset.up
        case .left:
            return Offset.left
        case .down:
            return Offset.down
        case .right:
            return Offset.right
        }
    }

    public var opposite: Direction {
        switch self {
        case .up:
            return .down
        case .left:
            return .right
        case .down:
            return .up
        case .right:
            return .left
        }
    }
}
