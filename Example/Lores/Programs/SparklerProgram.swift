import Lores

class SparklerProgram: Program {
    let numSparks = 400
    let gravity = 0.05
    var frame = 0;
    var genPosition = DPoint.zero
    var genHue: Frac = 0

    struct Spark {
        var position: DPoint
        var direction: Vector
        var hue: Frac
        var saturation: Frac
        let bornFrame: Int
        let dieFrame: Int
    }

    var sparks = [Spark]()

    override func setup() {
        canvasSize = Size(width: 150, height: 250)
        framesPerSecond = 60
        for _ in 0 ..< numSparks {
            sparks.append(makeSpark())
        }
    }

    override func update() {
        frame += 1

        for (i, spark) in sparks.enumerated() {
            var spark = spark
            spark.direction.dy += gravity
            spark.position += spark.direction
            if frame >= sparks[i].dieFrame || !canvas.isValidPoint(spark.position.point) {
                spark = makeSpark()
            }
            sparks[i] = spark
        }
    }

    override func draw() {
        for spark in sparks {
            let percentLived = Double(frame).lerpedToFrac(from: Double(spark.bornFrame) .. Double(spark.dieFrame))

            let bri: Frac
            if percentLived < 0.9 {
                bri = percentLived.lerpedFromFrac(to: 1.0 .. 2.0)
            } else {
                bri = 1.0
            }

            let color = Color(hue: spark.hue, saturation: spark.saturation, brightness: bri)
            canvas[spark.position.point] = color
        }
    }

    override func touchBeganAtPoint(_ point: Point) {
        genPosition = canvas.clampPoint(point).dpoint
        genHue = Random.number()
    }

    override func touchMovedAtPoint(_ point: Point) {
        genPosition = canvas.clampPoint(point).dpoint
    }

    private func makeSpark() -> Spark {
        let framesToLive = Random.number(20 ... 50)
        let bornFrame = frame
        let dieFrame = bornFrame + framesToLive

        let position = genPosition
        let angle = Random.number(0.0 .. Double.pi * 2)
        let speed = Random.number(0.5 .. 2.0)
        let direction = Vector(angle: angle, magnitude: speed)

        let hue: Frac
        let saturation: Frac
        switch Random.number(0 ... 2) {
        case 0:
            hue = genHue + 200.0 / 360.0
            saturation = 1
        case 1:
            hue = 0
            saturation = 0
        case 2:
            hue = genHue + 180.0 / 360.0
            saturation = 0.8
        default:
            preconditionFailure()
        }

        return Spark(position: position, direction: direction, hue: hue, saturation: saturation, bornFrame: bornFrame, dieFrame: dieFrame)
    }
}
