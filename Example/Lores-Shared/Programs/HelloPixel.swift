import Lores

class HelloPixelProgram : Program {
    
    override func draw()  {
        let p = Point(x: 0, y: 0)
        let c = Color.red
        canvas[p] = c
    }

}
