import Lores

class MandalaProgram: Program {
    var p1 = Point.zero
    var p2 = Point.zero

    override func setup() {
        framesPerSecond = 20
        canvas.clearColor = nil
        reset()
    }

    private func reset() {
        p1 = canvas.bounds.min
        p2 = canvas.bounds.max
    }

    override func draw() {
        let bounds = canvas.bounds

        if p1.x == bounds.maxX {
            reset()
        }

        let color = Color.random()
        canvas[0 ... bounds.maxX, p1.y] = color
        canvas[0 ... bounds.maxX, p2.y] = color
        canvas[p1.x, 0 ... bounds.maxY] = color
        canvas[p2.x, 0 ... bounds.maxY] = color

        p1.x += 1
        p1.y += 1
        p2.x -= 1
        p2.y -= 1
    }
}
