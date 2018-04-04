//
//  CanvasView.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

import WolfCore

class CanvasView : View {
    var touchBegan: ((_ point: CGPoint) -> Void)?
    var touchMoved: ((_ point: CGPoint) -> Void)?
    var touchEnded: ((_ point: CGPoint) -> Void)?
    var touchCancelled: ((_ point: CGPoint) -> Void)?

    var layerViews = [CanvasLayerView]()
    var screenSpec: ScreenSpec! {
        didSet {
            syncToScreen()
        }
    }

    private func syncToScreen() {
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
    }

    #if !os(macOS)
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
