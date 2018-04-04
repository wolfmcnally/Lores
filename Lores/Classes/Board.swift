//
//  Board.swift
//  Lores
//
//  Created by 🐺 McNally on 3/10/18.
//

public protocol TileValue {
    var shape: Shape { get }
}

public class Board<TileValueType: TileValue> {
    public var cells = [[TileValueType?]]()

    public init(size: Size, tileSize: Size) {
        self.size = size
        self.tileSize = tileSize
        syncBoard()
    }

    public var tileSize: Size

    public var size: Size

    public var bounds: Rect {
        return size.bounds
    }

    public var canvasSize: Size {
        return Size(width: tileSize.width * size.width, height: tileSize.height * size.height)
    }

    private func syncBoard() {
        cells = Array(repeating: Array(repeating: nil, count: bounds.width), count: bounds.height)
    }

    private func checkPoint(_ point: Point) {
        assert(point.x >= bounds.minX, "x must be >= 0")
        assert(point.y >= bounds.minY, "y must be >= 0")
        assert(point.x < bounds.size.width, "x must be < width")
        assert(point.y < bounds.size.height, "y must be < height")
    }

    private func offsetForPoint(_ point: Point) -> Point {
        return Point(x: point.x * tileSize.width, y: point.y * tileSize.height)
    }

    public func valueAtPoint(_ point: Point) -> TileValueType? {
        checkPoint(point)
        return cells[point.y][point.x]
    }

    public func setPoint(_ point: Point, to value: TileValueType?) {
        checkPoint(point)
        cells[point.y][point.x] = value
    }

    public subscript(point: Point) -> TileValueType? {
        get { return valueAtPoint(point) }
        set { setPoint(point, to: newValue) }
    }

    public subscript(x: Int, y: Int) -> TileValueType? {
        get { return valueAtPoint(Point(x: x, y: y)) }
        set { setPoint(Point(x: x, y: y), to: newValue) }
    }

    public func draw(into canvas: Canvas) {
        for y in bounds.minY ... bounds.maxY {
            for x in bounds.minX ... bounds.maxX {
                let point = Point(x: x, y: y)
                let offset = offsetForPoint(point)
                if let value = cells[y][x] {
                    let shape = value.shape
                    shape.draw(into: canvas, position: offset)
                } else {
                    let clearColor = canvas.clearColor ?? .clear
                    for py in 0 ..< tileSize.height {
                        for px in 0 ..< tileSize.width {
                            let p = Point(x: offset.x + px, y: offset.y + py)
                            canvas[p] = clearColor
                        }
                    }
                }
            }
        }
    }
}

