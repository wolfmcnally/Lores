import Lores

class RainingHeartsProgram: Program {
    let heartsCount = 50
    let minSpeed = 0.6
    let maxSpeed = 1.9

    var hearts = [MySprite]()

    override func setup() {
        canvasSize = Size(width: 340, height: 200)
        framesPerSecond = 30

        for _ in 0 ..< heartsCount {
            let index = Random.index(in: allShapes)
            let shape = allShapes[index]
            let sprite = MySprite(shape: shape)

            sprite.dPosition = canvas.randomPoint().dpoint

            var dirX = Double(index).lerped(from: 0 .. Double(allShapes.count) - 1, to: minSpeed .. maxSpeed)
            dirX += Random.number(0 .. 2)
            sprite.direction = Vector(dx: dirX, dy: dirX)

            let saturation = Random.number(0.8 .. 1.0)
            let minBrightness = 0.5
            let maxBrightness = 1.0
            let brightness = Double(index).lerped(from: 0 .. Double(allShapes.count) - 1, to: minBrightness .. maxBrightness)
            let hue: Double
            let colorPicker: Double = Random.number()
            switch colorPicker {
            case ..<0.48:
                // shade of purple-red heart
                hue = Random.number((290.0 / 360.0) .. (310.0 / 360.0))
            case ..<0.96:
                // shade of blue heart
                hue = Random.number(0.56 .. 0.58)
            default:
                // pure red heart
                hue = 0
            }
            let color = Color(hue: hue, saturation: saturation, brightness: brightness)
            sprite.shape.colors["❤️"] = color

            sprite.z = brightness

            hearts.append(sprite)
        }

        hearts.sort { $0.z < $1.z }
    }

    override func update() {
        for heart in hearts {
            heart.dPosition += heart.direction
            heart.position = heart.dPosition.point
        }
    }

    override func draw() {
        for heart in hearts {
            heart.draw(into: canvas)
        }
    }

    class MySprite: SimpleSprite {
        var direction: Vector = .zero
        var dPosition: DPoint = .zero
        var z: Double = 0

        init(shape: Shape) {
            super.init(shape: shape, mode: .wrap)
        }
    }

    let smallHeart = Shape(
        offset: Offset(dx: 2, dy: 1),
        rows: [
            "❔❤️❔❤️❔",
            "❤️❤️❤️❤️❤️",
            "❔❤️❤️❤️❔",
            "❔❔❤️❔❔"
        ]
    )

    let mediumHeart = Shape(
        offset: Offset(dx: 4, dy: 3),
        rows: [
            "❔❤️❤️❔❔❔❤️❤️❔",
            "❤️❤️❤️❤️❔❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❔❤️❤️❤️❤️❤️❤️❤️❔",
            "❔❔❤️❤️❤️❤️❤️❔❔",
            "❔❔❔❤️❤️❤️❔❔❔",
            "❔❔❔❔❤️❔❔❔❔"
        ]
    )

    let largeHeart = Shape(
        offset: Offset(dx: 6, dy: 4),
        rows: [
            "❔❔❤️❤️❤️❔❔❔❤️❤️❤️❔❔",
            "❔❤️❤️❤️❤️❤️❔❤️❤️❤️❤️❤️❔",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❔",
            "❔❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❔❔",
            "❔❔❔❤️❤️❤️❤️❤️❤️❤️❔❔❔",
            "❔❔❔❔❤️❤️❤️❤️❤️❔❔❔❔",
            "❔❔❔❔❔❤️❤️❤️❔❔❔❔❔",
            "❔❔❔❔❔❔❤️❔❔❔❔❔❔"
        ]
    )

    let xLargeHeart = Shape(
        offset: Offset(dx: 8, dy: 6),
        rows: [
            "❔❔❔❤️❤️❤️❤️❔❔❔❤️❤️❤️❤️❔❔❔",
            "❔❔❤️❤️❤️❤️❤️❤️❔❤️❤️❤️❤️❤️❤️❔❔",
            "❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❔",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❔",
            "❔❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❔❔",
            "❔❔❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❔❔❔",
            "❔❔❔❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❔❔❔❔",
            "❔❔❔❔❔❤️❤️❤️❤️❤️❤️❤️❔❔❔❔❔",
            "❔❔❔❔❔❔❤️❤️❤️❤️❤️❔❔❔❔❔❔",
            "❔❔❔❔❔❔❔❤️❤️❤️❔❔❔❔❔❔❔",
            "❔❔❔❔❔❔❔❔❤️❔❔❔❔❔❔❔❔"
        ]
    )

    private lazy var allShapes: [Shape] = [
        smallHeart,
        mediumHeart,
        largeHeart,
        xLargeHeart
    ]
}

