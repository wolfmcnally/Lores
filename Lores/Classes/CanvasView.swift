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

    var backgroundImage: UIImage? {
        get { return backgroundImageView.image }
        set { backgroundImageView.image = newValue }
    }

    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }

    private lazy var backgroundImageView = ImageView() • { 🍒 in
        🍒.layer.magnificationFilter = kCAFilterNearest
        🍒.contentMode = .scaleAspectFit
    }

    private lazy var imageView = ImageView() • { 🍒 in
        🍒.layer.magnificationFilter = kCAFilterNearest
        🍒.contentMode = .scaleAspectFit
    }

    override func setup() {
        super.setup()

        self => [
            backgroundImageView,
            imageView
        ]

        backgroundImageView.constrainFrameToFrame()
        imageView.constrainFrameToFrame()
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
