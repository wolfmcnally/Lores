//
//  Program.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

import WolfCore

public struct ScreenSpec {
    public var mainLayer: Int
    public var layerSpecs: [LayerSpec]

    public init(mainLayer: Int = 1, layerSpecs: [LayerSpec]) {
        self.mainLayer = mainLayer
        self.layerSpecs = layerSpecs
    }
}

public struct LayerSpec {
    public var clearColor: Color?

    public init(clearColor: Color? = nil) {
        self.clearColor = clearColor
    }
}

open class Program {
    private typealias `Self` = Program

    private var _canvasSize = Size(width: 40, height: 40)
    private var _framesPerSecond: Float = 0.0
    private var canceler: Cancelable?
    private var needsDisplay: Bool = true
    public var didDisplay: Block?
    public private(set) var frameNumber = 0
    public var onScreenChanged: ((ScreenSpec) -> Void)?

    public var screenSpec = ScreenSpec(
        mainLayer: 1,
        layerSpecs: [
            LayerSpec(clearColor: Color(color: .white, alpha: 0.05)),
            LayerSpec(clearColor: .clear)
        ]) {
        didSet { resetScreen() }
    }

    public private(set) var layers = [Canvas]()

    public var canvas: Canvas {
        return layers[screenSpec.mainLayer]
    }

    public var canvasClearColor: Color? {
        get { return canvas.clearColor }
        set { canvas.clearColor = newValue }
    }

    public var backgroundCanvas: Canvas {
        return layers[screenSpec.mainLayer - 1]
    }

    public var backgroundCanvasClearColor: Color? {
        get { return backgroundCanvas.clearColor }
        set { backgroundCanvas.clearColor = newValue }
    }

    private func resetScreen() {
        layers.removeAll()
        for layerSpec in screenSpec.layerSpecs {
            let layer = Canvas(size: canvasSize, clearColor: layerSpec.clearColor)
            layers.append(layer)
        }
        onScreenChanged?(self.screenSpec)
    }

    public var canvasSize: Size {
        get {
            return _canvasSize
        }
        set {
            _canvasSize = newValue
            resetScreen()
        }
    }

    private var displayLink: DisplayLink?

    public var framesPerSecond: Int = 0 {
        didSet {
            displayLink?.invalidate()
            guard framesPerSecond > 0 else { return }
            displayLink = DisplayLink(preferredFramesPerSecond: framesPerSecond) { [unowned self] _ in
                dispatchOnMain {
                    self._update()
                    self.displayIfNeeded()
                }
            }
        }
    }

    public init() {
        _setup()
    }

    private func _setup() {
        resetScreen()
        setup()
    }

    private var lastUpdateTime: TimeInterval?
    private var averageElapsedTime: TimeInterval?

    private func _update() {
        frameNumber += 1
        
        let updateTime = Date.timeIntervalSinceReferenceDate
        if let lastUpdateTime = lastUpdateTime {
            let elapsedTime = updateTime - lastUpdateTime
            if let averageElapsedTime = averageElapsedTime {
                self.averageElapsedTime = (elapsedTime + averageElapsedTime) / 2
            } else {
                averageElapsedTime = elapsedTime
            }
            //            print("target: \(1.0 / framesPerSecond) elapsed: \(elapsedTime) averageElapsed: \(averageElapsedTime!)")
        }
        lastUpdateTime = updateTime

        update()
        needsDisplay = true
    }

    public func display() {
        clear()
        draw()
        didDisplay?()
    }

    private func displayIfNeeded() {
        if needsDisplay {
            display()
            needsDisplay = false
        }
    }

    open func clear() {
        for layer in layers {
            layer.clear()
        }
    }

    open func setup() { }
    open func update() { }
    open func draw() { }

    open func touchBeganAtPoint(_ point: Point) { }
    open func touchMovedAtPoint(_ point: Point) { }
    open func touchEndedAtPoint(_ point: Point) { }
    open func touchCancelledAtPoint(_ point: Point) { }
}
