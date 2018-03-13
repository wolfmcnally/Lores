//
//  CanvasView.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

import WolfCore

class CanvasImageView: ImageView {
    override func setup() {
        super.setup()
        layer.magnificationFilter = kCAFilterNearest
        contentMode = .scaleAspectFit
    }
}

class CanvasView : View {
    var touchBegan: ((_ point: CGPoint) -> Void)?
    var touchMoved: ((_ point: CGPoint) -> Void)?
    var touchEnded: ((_ point: CGPoint) -> Void)?
    var touchCancelled: ((_ point: CGPoint) -> Void)?

    var layerViews = [ImageView]()
    var screenSpec: ScreenSpec! {
        didSet {
            syncToScreen()
        }
    }

    private func syncToScreen() {
        removeAllSubviews()
        layerViews.removeAll()
        screenSpec.layerSpecs.forEach { spec in
            let view = CanvasImageView()
            addSubview(view)
            view.constrainFrameToFrame()
            layerViews.append(view)
        }
    }

    override func setup() {
        super.setup()
    }

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
}
