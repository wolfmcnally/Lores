//
//  CanvasView.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

import WolfCore

#if os(macOS)
import AppKit
#else
import UIKit
#endif

#if os(tvOS)
import GameController
#endif

public typealias CGPointBlock = (CGPoint) -> Void
public typealias DirectionBlock = (Direction) -> Void

class CanvasView : View {
    #if os(macOS)

    var mouseDown: CGPointBlock?
    var mouseDragged: CGPointBlock?
    var mouseUp: CGPointBlock?

    var trackingArea: NSTrackingArea!
    var mouseEntered: CGPointBlock?
    var mouseMoved: CGPointBlock?
    var mouseExited: CGPointBlock?

    #else

    var touchBegan: CGPointBlock?
    var touchMoved: CGPointBlock?
    var touchEnded: CGPointBlock?
    var touchCancelled: CGPointBlock?

    #endif

    #if os(tvOS)
    var gestureActions: TVControllerActions!
    var gameController: GCController!
    var gameControllerConnectionAction: NotificationAction!
    var swiped: DirectionBlock?
    var directionButtonPressed: DirectionBlock?
    var directionButtonReleased: DirectionBlock?
    var lastControllerState: ControllerState?
    #endif

    var layerViews = [CanvasLayerView]()
    var screenSpec: ScreenSpec! {
        didSet {
            syncToScreen()
        }
    }

    override func setup() {
        super.setup()

        #if os(macOS)
        trackingArea = NSTrackingArea(rect: .zero, options: [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow, .inVisibleRect], owner: self)
        #endif

        #if os(tvOS)
        gestureActions = TVControllerActions(view: self)
        gestureActions.onSwipeUp = { [unowned self] _ in
            self.swiped?(.up)
        }
        gestureActions.onSwipeLeft = { [unowned self] _ in
            self.swiped?(.left)
        }
        gestureActions.onSwipeDown = { [unowned self] _ in
            self.swiped?(.down)
        }
        gestureActions.onSwipeRight = { [unowned self] _ in
            self.swiped?(.right)
        }

//        print("controllers: \(GCController.controllers())")
        gameControllerConnectionAction = NotificationAction(name: .GCControllerDidConnect, object: nil) { [unowned self] notification in
            print("connected")
            self.gameController = notification.object as! GCController
            let gamepad = self.gameController.microGamepad!
            gamepad.valueChangedHandler = { (gamepad, element) in
                let state = ControllerState(gamepad: gamepad)
                if let lastState = self.lastControllerState {
                    if state.up.isPressed != lastState.up.isPressed {
                        if state.up.isPressed {
                            self.directionButtonPressed?(.up)
                        } else {
                            self.directionButtonReleased?(.up)
                        }
                    }
                    if state.left.isPressed != lastState.left.isPressed {
                        if state.left.isPressed {
                            self.directionButtonPressed?(.left)
                        } else {
                            self.directionButtonReleased?(.left)
                        }
                    }
                    if state.down.isPressed != lastState.down.isPressed {
                        if state.down.isPressed {
                            self.directionButtonPressed?(.down)
                        } else {
                            self.directionButtonReleased?(.down)
                        }
                    }
                    if state.right.isPressed != lastState.right.isPressed {
                        if state.right.isPressed {
                            self.directionButtonPressed?(.right)
                        } else {
                            self.directionButtonReleased?(.right)
                        }
                    }
                }
                self.lastControllerState = state
            }
        }
        #endif
    }

    private func syncToScreen() {
        #if os(macOS)
        layerViews.last?.removeTrackingArea(trackingArea)
        #endif
        removeAllSubviews()
        layerViews.removeAll()
        screenSpec.layerSpecs.forEach { spec in
            let view = CanvasLayerView()
            addSubview(view)
            view.constrainCenterToCenter()
            view.constrainWidthToWidth(priority: .defaultLow)
            view.constrainHeightToHeight(priority: .defaultLow)
            view.constrainMaxHeightToHeight()
            view.constrainMaxWidthToWidth()
            view.constrainAspect(to: screenSpec.canvasSize.aspect)
            layerViews.append(view)
        }
        #if os(macOS)
        layerViews.last!.addTrackingArea(trackingArea)
        #endif
    }

    #if os(macOS)

    override func mouseDown(with event: NSEvent) {
        let loc = convert(event.locationInWindow, from: nil)
        mouseDown?(loc)
    }

    override func mouseDragged(with event: NSEvent) {
        let loc = convert(event.locationInWindow, from: nil)
        mouseDragged?(loc)
    }

    override func mouseUp(with event: NSEvent) {
        let loc = convert(event.locationInWindow, from: nil)
        mouseUp?(loc)
    }

    override func mouseEntered(with event: NSEvent) {
        let loc = convert(event.locationInWindow, from: nil)
        mouseEntered?(loc)
    }

    override func mouseMoved(with event: NSEvent) {
        let loc = convert(event.locationInWindow, from: nil)
        mouseMoved?(loc)
    }

    override func mouseExited(with event: NSEvent) {
        let loc = convert(event.locationInWindow, from: nil)
        mouseExited?(loc)
    }

    #else

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.location(in: self)
        touchBegan?(loc)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.location(in: self)
        touchMoved?(loc)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.location(in: self)
        touchEnded?(loc)
    }

    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        let touch = touches!.first!
        let loc = touch.location(in: self)
        touchCancelled?(loc)
    }

    #endif
}
