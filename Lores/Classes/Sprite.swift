//
//  Sprite.swift
//  Lores
//
//  Created by 🐺 McNally on 3/8/18.
//

open class Sprite {
    public var shape: Shape
    public var position: Point = .zero
    public var offset: Offset = .zero
    public var wraps = false

    public init(shape: Shape) {
        self.shape = shape
    }

    public func draw(into canvas: Canvas) {
        let wrapSize = wraps ? canvas.bounds.size : Size(width: Int.max, height: Int.max)
        for rowIndex in 0 ..< shape.rows.count {
            let y = position.y - offset.dy + rowIndex
            let row = Array(shape.rows[rowIndex])
            for (columnIndex, c) in row.enumerated() {
                guard let color = shape.colors[c]! else { continue }
                let x = position.x - offset.dx + columnIndex
                canvas[x % wrapSize.width, y % wrapSize.height] = color
            }
        }
    }
}
