import Lores
//import AudioKit

class SnakeProgram : Program {
    typealias `Self` = SnakeProgram

    var snake: [Point] = []
    var direction: Direction = .right
    var newDirection: Direction?
    var didCrash = false
    var growCounter = 0

    let wallColor = Color.blue.lightened(by: 0.5)
    let appleColor = Color.red.darkened(by: 0.5)
    let headColor = Color.green
    let tailColor = Color.green.darkened(by: 0.4)
    let bandColor = Color.green.darkened(by: 0.6)
    var frameCounter = 0
    var crunchSound: Sound!
    var bonebiteSound: Sound!
    var crashSound: Sound!

    override func setup() {
        crunchSound = Sound(name: "crunch")
        bonebiteSound = Sound(name: "bonebite")
        crashSound = Sound(name: "crash")
//        let sizeFactor = 3
//        canvasSize = Size(width: 16 * sizeFactor, height: 9 * sizeFactor)
        canvasSize = Size(width: 41, height: 36)
        backgroundCanvas.clearColor = nil
        resetGame()
    }

    func resetGame() {
        framesPerSecond = 4
        frameCounter = 0
        newDirection = nil
        startSnake()
        didCrash = false
    }

    override func update() {
        if didCrash {
            resetGame()
        } else {
            updateSnake()
            frameCounter += 1
            if growCounter > 0 {
                growCounter -= 1
            }
        }
    }

    override func draw() {
        drawSnake()

        if frameCounter == 0 {
            backgroundCanvas.clearToColor(.clear)
            drawBoard()

            addApples(3)
        }
    }

    func startSnake() {
        growCounter = 3
        direction = .up
        let p = Point(x: canvas.bounds.midX, y: canvas.bounds.maxY)
        snake = [p]
    }

    func drawBoard() {
        let b = backgroundCanvas.bounds
        backgroundCanvas[b.minX ... b.maxX, b.minY] = wallColor
        backgroundCanvas[b.minX ... b.maxX, b.maxY] = wallColor
        backgroundCanvas[b.minX, b.minY ... b.maxY] = wallColor
        backgroundCanvas[b.maxX, b.minY ... b.maxY] = wallColor

        let level = Self.levels[10]
        for line in level.lines {
            if line.y1 == line.y2 {
                backgroundCanvas[line.x1 ... line.x2, line.y1] = line.color
            } else if line.x1 == line.x2 {
                backgroundCanvas[line.x1, line.y1 ... line.y2] = line.color
            }
        }
    }

    func drawSnake() {
        let bandInterval = 6
        let bandWidth = 2
        let bandOffset = 2
        for i in 0 ..< snake.count {
            let n = (i + bandOffset) % bandInterval
            let color = n < bandWidth ? bandColor : tailColor
            canvas[snake[i]] = color
        }
        canvas[snake[0]] = headColor
    }

    func crash() {
        didCrash = true
    }

    func eat(at position: Point) {
        crunchSound.play()
        backgroundCanvas[position] = .clear
        addApple()
        growCounter += 4
        framesPerSecond += 1
    }

    func steer() {
        guard let newDirection = newDirection else { return }
        if newDirection != direction.opposite {
            direction = newDirection
        }
        self.newDirection = nil
    }

    func updateSnake() {
        steer()
        let currentPosition = snake[0]
        let newPosition = currentPosition + direction.offset

        if canvas[newPosition] != .clear {
            bonebiteSound.play()
            crash()
        }

        if backgroundCanvas[newPosition] == appleColor {
            eat(at: newPosition)
        } else if backgroundCanvas[newPosition] != .clear {
            crashSound.play()
            crash()
        }

        snake.insert(newPosition, at: 0)
        if growCounter == 0 {
            snake.removeLast()
        }
    }

    func addApples(_ count: Int) {
        for _ in 0 ..< count {
            addApple()
        }
    }

    func addApple() {
        while true {
            let p = canvas.bounds.randomPoint()
            if canvas[p] == .clear && backgroundCanvas[p] == .clear {
                backgroundCanvas[p] = appleColor
                return
            }
        }
    }

    override func keyDown(with key: Key) {
        guard newDirection == nil else { return }
        guard let direction = key.direction else { return }
        newDirection = direction
    }

    override func directionButtonPressed(in direction: Direction) {
        guard newDirection == nil else { return }
        newDirection = direction
    }

    enum WallType: Int {
        private typealias `Self` = WallType

        case wall1
        case wall2
        case wall3
        case wall4
        case wall5
        case wall6
        case wall7
        case wall8
        case wall9
        case wall10

        static let colors: [Color] = [
            .purple,
            .green,
            .red,
            Color.purple.darkened(by: 0.5),
            Color.green.darkened(by: 0.5),
            Color.purple.blend(to: Color.green, at: 0.5),
            Color.purple.blend(to: Color.red, at: 0.5),
            .yellow,
            .blue,
            .orange
        ]

        var color: Color {
            return Self.colors[rawValue]
        }
    }

    struct LevelLine {
        let x1: Int
        let y1: Int
        let x2: Int
        let y2: Int
        let wallType: WallType

        init(_ x1: Int, _ y1: Int, _ x2: Int, _ y2: Int, _ wallType: WallType) {
            self.x1 = x1
            self.y1 = y1
            self.x2 = x2
            self.y2 = y2
            self.wallType = wallType
        }

        var color: Color {
            return wallType.color
        }
    }

    struct Level {
        let lines: [LevelLine]
    }

    static let level1 = Level(
        lines: [
            LevelLine(11, 17, 28, 17, .wall1)
        ]
    )

    static let level2 = Level(
        lines: [
            LevelLine(20,  9, 20, 25, .wall1),
            LevelLine(12, 17, 28, 17, .wall1),
            ]
    )


    static let level3 = Level(
        lines: [
            LevelLine(11,  9, 28,  9, .wall6),
            LevelLine(11, 10, 11, 25, .wall6),
            LevelLine(12, 17, 28, 17, .wall6),
            LevelLine(12, 25, 28, 25, .wall6),
            ]
    )

    static let level4 = Level(
        lines: [
            LevelLine(11,  9, 11, 25, .wall8),
            LevelLine(20,  9, 20, 25, .wall8),
            LevelLine(28,  9, 28, 25, .wall8),
            LevelLine(12, 17, 19, 17, .wall4),
            LevelLine(21, 17, 27, 17, .wall4),
            ]
    )

    static let level5 = Level(
        lines: [
            LevelLine(11,  9, 18,  9, .wall7),
            LevelLine(21,  9, 28,  9, .wall7),
            LevelLine(11, 10, 11, 25, .wall7),
            LevelLine(28, 10, 28, 25, .wall7),
            LevelLine(12, 25, 28, 25, .wall7),
            ]
    )

    static let level6 = Level(
        lines: [
            LevelLine(11,  9, 11, 25, .wall7),
            LevelLine(16,  9, 28,  9, .wall7),
            LevelLine(28, 10, 28, 25, .wall7),
            LevelLine(12, 17, 23, 17, .wall7),
            LevelLine(16, 25, 28, 25, .wall7),
            ]
    )

    static let level7 = Level(
        lines: [
            LevelLine( 1, 16, 18, 16, .wall1),
            LevelLine(21, 17, 39, 17, .wall1),
            ]
    )

    static let level8 = Level(
        lines: [
            LevelLine( 5,  9,  5, 25, .wall1),
            LevelLine(10,  9, 10, 25, .wall2),
            LevelLine(15,  9, 15, 25, .wall3),
            LevelLine(20,  9, 20, 25, .wall6),
            LevelLine(25,  9, 25, 25, .wall3),
            LevelLine(30,  9, 30, 25, .wall2),
            LevelLine(35,  9, 35, 25, .wall1),
            ]
    )

    static let level9 = Level(
        lines: [
            LevelLine(11,  9, 24,  9, .wall8),
            LevelLine(28,  9, 28, 25, .wall6),
            LevelLine(11, 10, 11, 25, .wall8),
            LevelLine(15, 13, 28, 13, .wall6),
            LevelLine(12, 17, 24, 17, .wall8),
            LevelLine(15, 21, 28, 21, .wall6),
            LevelLine(12, 25, 24, 25, .wall8),
            ]
    )

    static let level10 = Level(
        lines: [
            LevelLine(11,  9, 28,  9, .wall7),
            LevelLine(11, 10, 11, 15, .wall7),
            LevelLine(20, 10, 20, 25, .wall7),
            LevelLine(28, 10, 28, 15, .wall7),
            LevelLine(11, 18, 11, 25, .wall7),
            LevelLine(28, 18, 28, 25, .wall7),
            LevelLine(12, 25, 28, 25, .wall7),
            ]
    )

    static let level11 = Level(
        lines: [
            LevelLine(11,  9, 28,  9, .wall6),
            LevelLine(11, 10, 11, 16, .wall6),
            LevelLine(28, 10, 28, 16, .wall6),
            LevelLine(20, 15, 20, 19, .wall7),
            LevelLine(11, 18, 11, 25, .wall6),
            LevelLine(28, 18, 28, 25, .wall6),
            LevelLine(12, 25, 28, 25, .wall6),
            ]
    )

    static let level12 = Level(
        lines: [
            LevelLine( 6,  5,  6, 11, .wall1),
            LevelLine(13,  5, 19,  5, .wall2),
            LevelLine(26,  5, 33,  5, .wall3),
            LevelLine(19,  6, 19, 11, .wall2),
            LevelLine(33,  6, 33, 18, .wall3),
            LevelLine( 7, 11, 12, 11, .wall1),
            LevelLine(20, 11, 25, 11, .wall2),
            LevelLine(26, 18, 33, 18, .wall3),
            LevelLine( 6, 19, 12, 19, .wall1),
            LevelLine(19, 19, 19, 24, .wall2),
            LevelLine(20, 24, 33, 24, .wall2),
            LevelLine( 6, 25,  6, 29, .wall3),
            LevelLine(33, 25, 33, 29, .wall2),
            LevelLine(12, 29, 28, 29, .wall1),
            ]
    )

    static let level13 = Level(
        lines: [
            LevelLine(17,  1, 17,  6, .wall6),
            LevelLine(17,  9, 17, 16, .wall6),
            LevelLine( 1, 16, 17, 16, .wall6),
            LevelLine(21, 19, 39, 19, .wall8),
            LevelLine(21, 20, 21, 25, .wall8),
            LevelLine(21, 28, 21, 34, .wall8),
            ]
    )

    static let level14 = Level(
        lines: [
            LevelLine(19,  1, 19, 14, .wall7),
            LevelLine( 1, 17, 16, 17, .wall7),
            LevelLine(22, 17, 39, 17, .wall7),
            LevelLine(19, 20, 19, 34, .wall7),
            ]
    )

    static let level15 = Level(
        lines: [
            LevelLine(21,  1, 21, 16, .wall9),
            LevelLine( 1, 16, 18, 16, .wall9),
            LevelLine(18, 19, 18, 34, .wall9),
            LevelLine(21, 19, 39, 19, .wall9),
            ]
    )

    static let level16 = Level(
        lines: [
            LevelLine(19,  1, 19,  7, .wall2),
            LevelLine(19,  9, 19, 25, .wall2),
            LevelLine( 1, 17,  9, 17, .wall2),
            LevelLine(11, 17, 28, 17, .wall2),
            LevelLine(30, 17, 39, 17, .wall2),
            LevelLine(19, 27, 19, 34, .wall2),
            ]
    )

    static let level17 = Level(
        lines: [
            LevelLine( 6,  5, 11,  5, .wall7),
            LevelLine(18,  5, 18,  7, .wall6),
            LevelLine(21,  5, 21,  7, .wall6),
            LevelLine(28,  5, 33,  5, .wall7),
            LevelLine(11,  6, 11, 10, .wall7),
            LevelLine(28,  6, 28, 10, .wall7),
            LevelLine(15,  7, 18,  7, .wall6),
            LevelLine(22,  7, 24,  7, .wall6),
            LevelLine( 8,  8,  8, 17, .wall7),
            LevelLine(15,  8, 15, 10, .wall6),
            LevelLine(24,  8, 24, 10, .wall6),
            LevelLine(31,  8, 31, 17, .wall7),
            LevelLine(18, 10, 21, 10, .wall8),
            LevelLine(20, 13, 20, 26, .wall8),
            LevelLine(11, 14, 15, 14, .wall6),
            LevelLine(24, 14, 28, 14, .wall6),
            LevelLine(11, 15, 11, 24, .wall6),
            LevelLine(28, 15, 28, 24, .wall6),
            LevelLine( 6, 17,  8, 17, .wall7),
            LevelLine(32, 17, 33, 17, .wall7),
            LevelLine( 6, 18,  6, 21, .wall7),
            LevelLine(33, 18, 33, 21, .wall7),
            LevelLine(15, 19, 24, 19, .wall8),
            LevelLine(12, 24, 15, 24, .wall6),
            LevelLine(24, 24, 28, 24, .wall6),
            LevelLine( 6, 25,  6, 29, .wall4),
            LevelLine(33, 25, 33, 29, .wall4),
            LevelLine(15, 27, 15, 29, .wall9),
            LevelLine(24, 27, 24, 29, .wall9),
            LevelLine(11, 28, 11, 29, .wall4),
            LevelLine(28, 28, 28, 29, .wall4),
            LevelLine( 7, 29, 11, 29, .wall4),
            LevelLine(16, 29, 24, 29, .wall9),
            LevelLine(29, 29, 33, 29, .wall4),
            ]
    )

    static let level18 = Level(
        lines: [
            LevelLine( 6,  5, 18,  5, .wall8),
            LevelLine(21,  5, 33,  5, .wall8),
            LevelLine( 6,  6,  6, 29, .wall8),
            LevelLine(33,  6, 33, 29, .wall8),
            LevelLine(11, 10, 28, 10, .wall6),
            LevelLine(11, 11, 11, 24, .wall6),
            LevelLine(28, 11, 28, 16, .wall6),
            LevelLine(28, 19, 28, 24, .wall6),
            LevelLine(12, 24, 28, 24, .wall6),
            LevelLine( 7, 29, 18, 29, .wall8),
            LevelLine(21, 29, 33, 29, .wall8),
            ]
    )

    static let level19 = Level(
        lines: [
            LevelLine(11,  8, 28,  8, .wall9),
            LevelLine(20,  9, 20, 15, .wall9),
            LevelLine( 9, 10,  9, 24, .wall9),
            LevelLine(30, 10, 30, 24, .wall9),
            LevelLine(10, 17, 18, 17, .wall9),
            LevelLine(22, 17, 30, 17, .wall9),
            LevelLine(20, 19, 20, 26, .wall9),
            LevelLine(11, 26, 28, 26, .wall9),
            ]
    )

    static let level20 = Level(
        lines: [
            LevelLine(18,  1, 18,  5, .wall1),
            LevelLine(21,  1, 21, 26, .wall1),
            LevelLine(18,  8, 18, 34, .wall1),
            LevelLine(21, 29, 21, 34, .wall1),
            ]
    )

    static let level21 = Level(
        lines: [
            LevelLine( 5,  4, 34,  4, .wall1),
            LevelLine( 8,  5,  8, 29, .wall1),
            LevelLine( 5,  7,  5, 29, .wall1),
            LevelLine(11,  7, 34,  7, .wall2),
            LevelLine(11,  8, 11, 29, .wall2),
            LevelLine(14, 10, 34, 10, .wall3),
            LevelLine(14, 11, 14, 29, .wall3),
            LevelLine(17, 13, 34, 13, .wall7),
            LevelLine(17, 14, 17, 29, .wall7),
            LevelLine(20, 16, 34, 16, .wall6),
            LevelLine(20, 17, 20, 29, .wall6),
            LevelLine(23, 19, 34, 19, .wall8),
            LevelLine(23, 20, 23, 29, .wall8),
            LevelLine(26, 22, 34, 22, .wall4),
            LevelLine(26, 23, 26, 29, .wall4),
            LevelLine(29, 25, 34, 25, .wall5),
            LevelLine(29, 26, 29, 29, .wall5),
            LevelLine(32, 29, 34, 29, .wall9),
            ]
    )

    static let level22 = Level(
        lines: [
            LevelLine(28,  5, 28,  7, .wall6),
            LevelLine(31,  5, 31,  7, .wall6),
            LevelLine( 2,  7,  9,  7, .wall7),
            LevelLine(12,  7, 19,  7, .wall7),
            LevelLine(21,  7, 28,  7, .wall6),
            LevelLine(32,  7, 37,  7, .wall6),
            LevelLine( 2,  8,  2, 16, .wall7),
            LevelLine( 9,  8,  9,  9, .wall7),
            LevelLine(12,  8, 12,  9, .wall7),
            LevelLine(19,  8, 19, 16, .wall7),
            LevelLine(21,  8, 21, 16, .wall6),
            LevelLine(37,  8, 37, 16, .wall6),
            LevelLine( 3, 16, 19, 16, .wall7),
            LevelLine(22, 16, 37, 16, .wall6),
            LevelLine( 2, 18, 19, 18, .wall8),
            LevelLine(21, 18, 37, 18, .wall4),
            LevelLine( 2, 19,  2, 27, .wall8),
            LevelLine(19, 19, 19, 27, .wall8),
            LevelLine(21, 19, 21, 27, .wall4),
            LevelLine(37, 19, 37, 27, .wall4),
            LevelLine(28, 25, 28, 27, .wall4),
            LevelLine(31, 25, 31, 27, .wall4),
            LevelLine( 3, 27,  9, 27, .wall8),
            LevelLine(12, 27, 19, 27, .wall8),
            LevelLine(22, 27, 28, 27, .wall4),
            LevelLine(32, 27, 37, 27, .wall4),
            LevelLine( 9, 28,  9, 29, .wall8),
            LevelLine(12, 28, 12, 29, .wall8),
            ]
    )

    static let level23 = Level(
        lines: [
            LevelLine(15,  1, 15, 14, .wall8),
            LevelLine(19,  1, 19, 14, .wall8),
            LevelLine(23,  1, 23, 14, .wall8),
            LevelLine(17,  2, 17, 16, .wall5),
            LevelLine(21,  2, 21, 16, .wall5),
            LevelLine(15, 16, 23, 16, .wall5),
            LevelLine(15, 18, 23, 18, .wall5),
            LevelLine(17, 19, 17, 33, .wall5),
            LevelLine(21, 19, 21, 33, .wall5),
            LevelLine(15, 20, 15, 34, .wall8),
            LevelLine(19, 20, 19, 34, .wall8),
            LevelLine(23, 20, 23, 34, .wall8),
            ]
    )

    static let level24 = Level(
        lines: [
            LevelLine( 5,  5, 10,  5, .wall7),
            LevelLine(12,  5, 12,  7, .wall6),
            LevelLine(27,  5, 27,  7, .wall6),
            LevelLine(29,  5, 34,  5, .wall7),
            LevelLine( 5,  6,  5, 10, .wall7),
            LevelLine(34,  6, 34, 10, .wall7),
            LevelLine( 7,  7, 12,  7, .wall6),
            LevelLine(14,  7, 25,  7, .wall8),
            LevelLine(28,  7, 32,  7, .wall6),
            LevelLine( 7,  8,  7, 12, .wall6),
            LevelLine(32,  8, 32, 12, .wall6),
            LevelLine( 9,  9, 18,  9, .wall4),
            LevelLine(21,  9, 30,  9, .wall4),
            LevelLine( 9, 10,  9, 16, .wall4),
            LevelLine(30, 10, 30, 16, .wall4),
            LevelLine( 5, 12,  7, 12, .wall6),
            LevelLine(33, 12, 34, 12, .wall6),
            LevelLine( 7, 14,  7, 21, .wall8),
            LevelLine(32, 14, 32, 21, .wall8),
            LevelLine( 9, 19,  9, 26, .wall4),
            LevelLine(30, 19, 30, 26, .wall4),
            LevelLine( 5, 23,  7, 23, .wall6),
            LevelLine(32, 23, 34, 23, .wall6),
            LevelLine( 7, 24,  7, 28, .wall6),
            LevelLine(32, 24, 32, 28, .wall6),
            LevelLine( 5, 25,  5, 30, .wall7),
            LevelLine(34, 25, 34, 30, .wall7),
            LevelLine(10, 26, 18, 26, .wall4),
            LevelLine(21, 26, 30, 26, .wall4),
            LevelLine( 8, 28, 12, 28, .wall6),
            LevelLine(14, 28, 25, 28, .wall8),
            LevelLine(27, 28, 32, 28, .wall6),
            LevelLine(12, 29, 12, 30, .wall6),
            LevelLine(27, 29, 27, 30, .wall6),
            LevelLine( 6, 30, 10, 30, .wall7),
            LevelLine(29, 30, 34, 30, .wall7),
            ]
    )

    static let level25 = Level(
        lines: [
            LevelLine(27,  1, 27,  7, .wall3),
            LevelLine(34,  4, 34,  9, .wall3),
            LevelLine(28,  7, 32,  7, .wall3),
            LevelLine(36,  7, 39,  7, .wall3),
            LevelLine(27,  9, 37,  9, .wall3),
            LevelLine(27, 10, 27, 23, .wall3),
            LevelLine(12, 12, 24, 12, .wall2),
            LevelLine(12, 13, 12, 26, .wall2),
            LevelLine(24, 13, 24, 20, .wall2),
            LevelLine(15, 15, 21, 15, .wall3),
            LevelLine(15, 16, 15, 23, .wall3),
            LevelLine(21, 16, 21, 17, .wall3),
            LevelLine(18, 18, 18, 20, .wall2),
            LevelLine(19, 20, 24, 20, .wall2),
            LevelLine(16, 23, 27, 23, .wall3),
            LevelLine( 2, 26, 12, 26, .wall2),
            LevelLine( 5, 27,  5, 31, .wall2),
            LevelLine( 1, 28,  3, 28, .wall2),
            LevelLine( 7, 28, 12, 28, .wall2),
            LevelLine(12, 29, 12, 34, .wall2),
            ]
    )

    static let level26 = Level(
        lines: [
            LevelLine(17,  2, 17,  5, .wall7),
            LevelLine(23,  2, 23,  5, .wall7),
            LevelLine(18,  5, 23,  5, .wall7),
            LevelLine(10,  7, 19,  7, .wall6),
            LevelLine(21,  7, 29,  7, .wall6),
            LevelLine(10,  8, 10, 13, .wall6),
            LevelLine(29,  8, 29, 13, .wall6),
            LevelLine( 1, 15,  8, 15, .wall6),
            LevelLine(10, 15, 10, 26, .wall6),
            LevelLine(29, 15, 29, 26, .wall6),
            LevelLine(31, 15, 39, 15, .wall6),
            LevelLine(11, 19, 15, 19, .wall6),
            LevelLine(17, 19, 22, 19, .wall6),
            LevelLine(24, 19, 29, 19, .wall6),
            LevelLine( 2, 24,  8, 24, .wall8),
            LevelLine(31, 24, 37, 24, .wall8),
            LevelLine( 8, 25,  8, 33, .wall8),
            LevelLine(31, 25, 31, 33, .wall8),
            LevelLine(16, 29, 19, 29, .wall8),
            LevelLine(21, 29, 24, 29, .wall8),
            LevelLine(16, 30, 16, 33, .wall8),
            LevelLine(24, 30, 24, 33, .wall8),
            LevelLine( 9, 33, 16, 33, .wall8),
            LevelLine(25, 33, 31, 33, .wall8),
            ]
    )

    static let level27 = Level(
        lines: [
            LevelLine( 2, 10,  9, 10, .wall7),
            LevelLine( 2, 11,  2, 16, .wall7),
            LevelLine( 3, 16,  9, 16, .wall7),
            LevelLine(12, 16, 12, 23, .wall3),
            LevelLine(15, 16, 18, 16, .wall6),
            LevelLine(21, 16, 21, 23, .wall8),
            LevelLine(24, 16, 24, 23, .wall4),
            LevelLine(29, 16, 29, 23, .wall4),
            LevelLine(32, 16, 37, 16, .wall5),
            LevelLine( 9, 17,  9, 23, .wall7),
            LevelLine(15, 17, 15, 23, .wall6),
            LevelLine(32, 17, 32, 19, .wall5),
            LevelLine(33, 19, 37, 19, .wall5),
            LevelLine(37, 20, 37, 23, .wall5),
            LevelLine( 2, 23,  9, 23, .wall7),
            LevelLine(25, 23, 29, 23, .wall4),
            LevelLine(32, 23, 37, 23, .wall5),
            ]
    )

    static let rip = Level(
        lines: [
            LevelLine( 6,  4, 33,  4, .wall6),
            LevelLine( 6,  5,  6, 25, .wall6),
            LevelLine(33,  5, 33, 25, .wall6),
            LevelLine(10,  8, 10, 17, .wall6),
            LevelLine(23,  8, 23, 23, .wall6),
            LevelLine(11,  9, 14,  9, .wall6),
            LevelLine(18,  9, 18, 17, .wall6),
            LevelLine(24,  9, 27,  9, .wall6),
            LevelLine(27, 10, 27, 17, .wall6),
            LevelLine(13, 17, 13, 17, .wall6),
            LevelLine(20, 17, 20, 17, .wall6),
            LevelLine(24, 17, 27, 17, .wall6),
            LevelLine(30, 17, 30, 17, .wall6),
            LevelLine(10, 19, 21, 19, .wall6),
            LevelLine(25, 19, 27, 19, .wall6),
            LevelLine( 7, 25, 33, 25, .wall6),
            ]
    )

    static let levels = [
        level1,
        level2,
        level3,
        level4,
        level5,
        level6,
        level7,
        level8,
        level9,
        level10,
        level11,
        level12,
        level13,
        level14,
        level15,
        level16,
        level17,
        level18,
        level19,
        level20,
        level21,
        level22,
        level23,
        level24,
        level25,
        level26,
        level27,
        rip
    ]
}

