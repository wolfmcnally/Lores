import Lores

class MoveProgram : Program {
    var redPosition = Point(x: 0, y: 0)
    var bluePosition = Point(x: 0, y: 0)
    var redDirection = 1
    var blueDirection = 1

    override func setup() {
        framesPerSecond = 30
        canvasSize = Size(width: 40, height: 30)
    }
    
    override func update() {
        let bounds = canvas.bounds

        let newx = redPosition.x + redDirection
        if newx == bounds.maxX {
            redDirection = -1
        } else if newx == 0 {
            redDirection = 1
        }
        redPosition = Point(x: newx, y: bounds.midY)

        let newy = bluePosition.y + blueDirection
        if newy == bounds.maxY {
            blueDirection = -1
        } else if newy == 0 {
            blueDirection = 1
        }
        bluePosition = Point(x: bounds.midX, y: newy)
    }
    
    override func draw()  {
        canvas[redPosition] = .red
        canvas[bluePosition] = .blue
    }
    
}
