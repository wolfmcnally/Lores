//
//  Board.swift
//  Lores
//
//  Created by 🐺 McNally on 3/10/18.
//

public protocol CellValue {
    var shape: Shape { get }
}

public class Board<CellValueType: CellValue> {
    public var cells = [[CellValueType?]]()

    public init(size: Size, cellSize: Size) {
        self.size = size
        self.cellSize = cellSize
        syncBoard()
    }

    public var cellSize: Size

    public var size: Size

    public var bounds: Rect {
        return size.bounds
    }

    public var canvasSize: Size {
        return Size(width: cellSize.width * size.width, height: cellSize.height * size.height)
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
        return Point(x: point.x * cellSize.width, y: point.y * cellSize.height)
    }

    public func valueAtPoint(_ point: Point) -> CellValueType? {
        checkPoint(point)
        return cells[point.y][point.x]
    }

    public func setPoint(_ point: Point, to value: CellValueType?) {
        checkPoint(point)
        cells[point.y][point.x] = value
    }

    public subscript(point: Point) -> CellValueType? {
        get { return valueAtPoint(point) }
        set { setPoint(point, to: newValue) }
    }

    public subscript(x: Int, y: Int) -> CellValueType? {
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
                    for py in 0 ..< cellSize.height {
                        for px in 0 ..< cellSize.width {
                            let p = Point(x: offset.x + px, y: offset.y + py)
                            canvas[p] = clearColor
                        }
                    }
                }
            }
        }
    }
}

