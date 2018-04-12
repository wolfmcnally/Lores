//
//  Key.swift
//  Lores
//
//  Created by 🐺 McNally on 4/7/18.
//

#if os(macOS)
import AppKit
#endif

public enum KeyType {
    case arrow(Direction)
}

public struct Key {
    public let type: KeyType

    public init(type: KeyType) {
        self.type = type
    }

    #if os(macOS)
    public init?(event: NSEvent) {
        guard !event.isARepeat else { return nil }

        let keyType: KeyType
        switch event.keyCode {
        case 123:
            keyType = .arrow(.left)
        case 124:
            keyType = .arrow(.right)
        case 125:
            keyType = .arrow(.down)
        case 126:
            keyType = .arrow(.up)
        default:
            return nil
        }
        self.init(type: keyType)
    }
    #endif

    public var direction: Direction? {
        switch type {
        case .arrow(let direction):
            return direction
        }
    }

    public var offset: Offset? {
        return direction?.offset
    }
}
