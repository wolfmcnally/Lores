//
//  ProgramView.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

import WolfCore

public class ProgramView: View {
    public var program: Program!
    private var canvasView: CanvasView!
    private var backgroundView: BackgroundView!

    public var backgroundImage: UIImage? {
        get { return backgroundView.image }
        set { backgroundView.image = newValue }
    }

    public var backgroundTintColor: UIColor? {
        get { return backgroundView.tintColor }
        set { backgroundView.tintColor = newValue }
    }

    override public func setup() {
        super.setup()

        layer.magnificationFilter = kCAFilterNearest

        addBackgroundView()
        addCanvasView()
    }

    func addBackgroundView() {
        backgroundView = BackgroundView(frame: bounds)
        addSubview(backgroundView)
        backgroundView.constrainFrameToFrame()
    }

    func addCanvasView() {
        canvasView = CanvasView(frame: bounds)
        addSubview(canvasView)
        canvasView.constrainFrameToFrame()

        canvasView.touchBegan = { [unowned self] point in
            self.program.touchBeganAtPoint(self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.touchMoved = { [unowned self] point in
            self.program.touchMovedAtPoint(self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.touchEnded = { [unowned self] point in
            self.program.touchEndedAtPoint(self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.touchCancelled = { [unowned self] point in
            self.program.touchCancelledAtPoint(self.canvasPointForCanvasViewPoint(point))
        }
    }

    public func flush() {
        canvasView.backgroundImage = program.backgroundCanvas.image
        canvasView.image = program.canvas.image
    }

    func canvasPointForCanvasViewPoint(_ point: CGPoint) -> Point {
        let canvasImageSize = self.program.canvas.image.size
        let canvasImageSizeScaled = canvasImageSize.aspectFit(within: self.canvasView.bounds.size)
        let canvasImageFrame = CGRect(origin: .zero, size: canvasImageSizeScaled).settingMidXmidY(self.canvasView.bounds.midXmidY)
        let fx = point.x.lerped(from: canvasImageFrame.minX..canvasImageFrame.maxX, to: CGFloat(0)..canvasImageSize.width)
        let fy = point.y.lerped(from: canvasImageFrame.minY..canvasImageFrame.maxY, to: CGFloat(0)..canvasImageSize.height)
        let x = Int(floor(fx))
        let y = Int(floor(fy))
        let p = Point(x: x, y: y)
        return p
    }
}
