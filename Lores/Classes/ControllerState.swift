//
//  GameController.swift
//  Pods
//
//  Created by Wolf McNally on 4/7/18.
//

import GameController

public struct ControllerState {
    public struct Button {
        public var value: Float = 0
        public var isPressed: Bool { return value > 0.5 }
    }

    public var buttonA = Button()
    public var buttonX = Button()

    public var up = Button()
    public var left = Button()
    public var down = Button()
    public var right = Button()

    public init(gamepad: GCMicroGamepad) {
        self.buttonA.value = gamepad.buttonA.value
        self.buttonX.value = gamepad.buttonX.value

        self.up.value = gamepad.dpad.up.value
        self.left.value = gamepad.dpad.left.value
        self.down.value = gamepad.dpad.down.value
        self.right.value = gamepad.dpad.right.value
    }

    public var directionsPressed: Set<Direction> {
        var s = Set<Direction>()
        if up.isPressed { s.insert(.up) }
        if left.isPressed { s.insert(.left) }
        if down.isPressed { s.insert(.down) }
        if right.isPressed { s.insert(.right) }
        return s
    }
}
