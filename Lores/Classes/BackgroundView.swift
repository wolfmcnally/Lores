//
//  BackgroundView.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

import WolfCore

#if os(macOS)

class BackgroundView : ImageView {
    override func setup() {
        super.setup()

        imageScaling = .scaleAxesIndependently
        imageAlignment = .alignCenter
    }

    var backgroundTintColor: NSColor? {
        didSet { setNeedsDisplay() }
    }

    override var intrinsicContentSize: NSSize {
        return NSSize(width: NSView.noIntrinsicMetric, height: NSView.noIntrinsicMetric)
    }

    override func draw(_ dirtyRect: NSRect) {
        if let backgroundTintColor = backgroundTintColor {
            backgroundTintColor.set()
            NSBezierPath.fill(bounds)
        }
        super.draw(dirtyRect)
    }
}

#else

class BackgroundView : ImageView {
    override func setup() {
        super.setup()

        contentMode = .scaleAspectFill
        backgroundColor = UIColor.black
    }

    var backgroundTintColor: UIColor? {
        get { return tintColor }
        set { tintColor = newValue }
    }
}

#endif
