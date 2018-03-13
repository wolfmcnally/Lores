//
//  Shape.swift
//  Lores
//
//  Created by 🐺 McNally on 3/8/18.
//

import WolfCore

public struct Shape {
    public var colors: ColorTable
    public var offset: Offset
    public var rows: [String]

    public init(colors: ColorTable = .standardColors, offset: Offset = .zero, rows: [String] = []) {
        self.colors = colors
        self.offset = offset
        self.rows = rows
    }

    public enum Mode {
        case fence  // abort if pixels are drawn outside of canvas
        case wrap   // pixels drawn off one side of the canvas are drawn on the other
        case clip   // pixles drawn off the side of the canvas are clipped
    }

    public func draw(into canvas: Canvas, position: Point, mode: Mode = .fence) {
        for rowIndex in 0 ..< rows.count {
            var y = position.y - offset.dy + rowIndex
            switch mode {
            case .fence:
                break
            case .wrap:
                y = mod(y, canvas.bounds.size.height)
            case .clip:
                guard canvas.bounds.rangeY.contains(y) else { continue }
            }
            let row = Array(rows[rowIndex])
            for (columnIndex, c) in row.enumerated() {
                guard let color = colors[c] else { continue }
                var x = position.x - offset.dx + columnIndex
                switch mode {
                case .fence:
                    break
                case .wrap:
                    x = mod(x, canvas.bounds.size.width)
                case .clip:
                    guard canvas.bounds.rangeX.contains(x) else { continue }
                }
                canvas[x, y] = color
            }
        }
    }
}
