//
//  ProgramView.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

import WolfCore

public class ProgramView: View {
    public var program: Program! {
        didSet {
            syncToProgram()
        }
    }
    private var canvasView: CanvasView! {
        didSet {
            syncToProgram()
        }
    }

    private var backgroundView: BackgroundView!

    public var backgroundImage: OSImage? {
        get { return backgroundView.image }
        set { backgroundView.image = newValue }
    }

    public var backgroundTintColor: OSColor? {
        get { return backgroundView.backgroundTintColor }
        set { backgroundView.backgroundTintColor = newValue }
    }

    override public func setup() {
        super.setup()
        addBackgroundView()
        addCanvasView()
    }

    private func syncToProgram() {
        guard let program = program else { return }
        program.onScreenChanged = { [unowned self] screenSpec in
            self.canvasView?.screenSpec = screenSpec
        }
        canvasView?.screenSpec = program.screenSpec
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

        #if os(macOS)

        canvasView.mouseDown = { [unowned self] point in
            self.program.mouseDown(at: self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.mouseDragged = { [unowned self] point in
            self.program.mouseDragged(at: self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.mouseUp = { [unowned self] point in
            self.program.mouseUp(at: self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.mouseMoved = { [unowned self] point in
            self.program.mouseMoved(at: self.canvasPointForCanvasViewPoint(point))
        }

        #else

        canvasView.touchBegan = { [unowned self] point in
            self.program.touchBegan(at: self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.touchMoved = { [unowned self] point in
            self.program.touchMoved(at: self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.touchEnded = { [unowned self] point in
            self.program.touchEnded(at: self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.touchCancelled = { [unowned self] point in
            self.program.touchCancelled(at: self.canvasPointForCanvasViewPoint(point))
        }

        #endif
    }

    public func flush() {
        for (view, canvas) in zip(canvasView.layerViews, program.layers) {
            view.image = canvas.image
        }
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
