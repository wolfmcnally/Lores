//
//  CanvasLayerView.swift
//  Pods
//
//  Created by Wolf McNally on 4/4/18.
//

import WolfCore

#if os(macOS)

class CanvasLayerView: View {
    override func setup() {
        super.setup()
        wantsLayer = true
        osLayer.magnificationFilter = kCAFilterNearest
    }

    var image: OSImage? {
        didSet {
            setNeedsDisplay(bounds)
        }
    }

    public override func updateLayer() {
        super.updateLayer()
        osLayer.contents = image?.cgImage
    }

    public override var wantsUpdateLayer: Bool {
        return true
    }
}

#else

class CanvasLayerView: View {
    override func setup() {
        super.setup()
        osLayer.magnificationFilter = kCAFilterNearest
    }

    var image: OSImage? {
        didSet {
            layer.contents = image!.cgImage
        }
    }
}

#endif
