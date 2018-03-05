//
//  Program.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

import WolfCore

open class Program {
    private var _canvasSize = Size(width: 40, height: 40)
    private var _canvas: Canvas?
    private var _backgroundCanvas: Canvas?
    private var _framesPerSecond: Float = 0.0
    private var canceler: Cancelable?
    private var needsDisplay: Bool = true
    public var didDisplay: Block?
    public private(set) var frameNumber = 0

    public private(set) var canvas: Canvas! {
        get {
            if _canvas == nil {
                _canvas = Canvas(size: canvasSize, clearColor: .clear)
            }
            return _canvas
        }
        set { _canvas = newValue }
    }

    public private(set) var backgroundCanvas: Canvas! {
        get {
            if _backgroundCanvas == nil {
                _backgroundCanvas = Canvas(size: canvasSize, clearColor: Color(color: .white, alpha: 0.05))
            }
            return _backgroundCanvas
        }
        set { _backgroundCanvas = newValue }
    }

    private func invalidateCanvas() {
        canvas = nil
        backgroundCanvas = nil
    }

    public var canvasSize: Size {
        get {
            return _canvasSize
        }
        set {
            _canvasSize = newValue
            invalidateCanvas()
        }
    }

    private var queue = DispatchQueue(label: "Program Queue", qos: DispatchQoS.init(qosClass: .userInteractive, relativePriority: 0), attributes: [])
    private var dispatchSource: DispatchSourceTimer!

    public var framesPerSecond: Float {
        get {
            return _framesPerSecond
        }
        set {
            if _framesPerSecond != newValue {
                _framesPerSecond = newValue
                let interval = TimeInterval(Float(1.0) / _framesPerSecond)
                dispatchSource?.cancel()
                dispatchSource = DispatchSource.makeTimerSource(flags: [.strict], queue: queue)
                dispatchSource.schedule(deadline: .now(), repeating: interval, leeway: DispatchTimeInterval.milliseconds(0))
                dispatchSource.setEventHandler { [unowned self] in
                    self._update()
                    dispatchOnMain {
                        self.displayIfNeeded()
                    }
                }
                dispatchSource.resume()
            }
        }
    }

    public init() {
        _setup()
    }

    private func _setup() {
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
        backgroundCanvas.clear()
        canvas.clear()
    }

    open func setup() { }
    open func update() { }
    open func draw() { }

    open func touchBeganAtPoint(_ point: Point) { }
    open func touchMovedAtPoint(_ point: Point) { }
    open func touchEndedAtPoint(_ point: Point) { }
    open func touchCancelledAtPoint(_ point: Point) { }
}
