import Lores
import func WolfCore.dispatchOnQueue
import func WolfCore.dispatchOnMain
import Dispatch

public class SwiftLesson: Program {
    private let boardSize = Size(width: 5, height: 5)
    private let cellSize = Size(width: 5, height: 5)
    private let runQueue = DispatchQueue(label: "run")

    private lazy var landscapeLayer = Board<LandscapeCellValue>(size: boardSize, cellSize: cellSize)
    private lazy var floatingLayer = Board<FloatingCellValue>(size: boardSize, cellSize: cellSize)

    private var player: Player!
    private let landscape: Landscape
    private var gemCount: Int {
        didSet {
            if gemCount == 0 {
                print("All gems collected!")
            }
        }
    }

    public init(landscape: Landscape) {
        self.landscape = landscape
        gemCount = 0
        super.init()
        
        for y in 0 ..< landscape.rows.count {
            let row = Array(landscape.rows[y])
            for (x, c) in row.enumerated() {
                let p = Point(x: x, y: y)

                landscapeLayer[p] = LandscapeCellValue.tile(for: c)

                if let heading = Player.heading(for: c) {
                    self.player = Player(heading: heading, boardPosition: p)
                }

                if let tile = FloatingCellValue.tile(for: c) {
                    floatingLayer[p] = tile
                    if tile == .gem {
                        gemCount += 1
                    }
                }
            }
        }
    }


    public override func setup() {
        canvasSize = landscapeLayer.canvasSize
        framesPerSecond = 10

        screenSpec = ScreenSpec(layerSpecs: [
            LayerSpec(),
            LayerSpec(clearColor: .clear),
            LayerSpec()
            ])

        dispatchOnQueue(runQueue, afterDelay: 1) {
            self.run()
        }
    }

    open func run () {
    }

    public override func draw() {
        landscapeLayer.draw(into: layers[0])
        player.draw(into: layers[1])
        floatingLayer.draw(into: layers[2])
    }

    enum LandscapeCellValue: CellValue {
        private typealias `Self` = LandscapeCellValue

        case path
        case rough
        case water

        var shape: Shape {
            switch self {
            case .path: return Self.pathShape
            case .rough: return Self.roughShape
            case .water: return Self.waterShape
            }
        }

        static func tile(for c: Character) -> LandscapeCellValue {
            switch c {
            case "⬆️", "⬅️", "⬇️", "➡️", "🍋", "❤️": return .path
            case "🍏": return .rough
            case "🦋": return .water
            default:
                preconditionFailure()
            }
        }

        static let pathShape = Shape(
            rows: [
                "🍋🍋🍋🍋🍋",
                "🍋🍋🍋🍋🍋",
                "🍋🍋🍋🍋🍋",
                "🍋🍋🍋🍋🍋",
                "🍋🍋🍋🍋🍋"
            ]
        )

        static let roughShape = Shape(
            colors:
            ColorTable([
                "💣": Color.brown.darkened(by: 0.2),
                "🐻": .brown
                ]),
            rows: [
                "💣🐻🐻🐻🐻",
                "🐻💣🐻🐻🐻",
                "🐻🐻🐻🐻💣",
                "🐻🐻💣🐻🐻",
                "🐻🐻🐻🐻🐻",
                ]
        )

        static let waterShape = Shape(
            colors:
            ColorTable([
                "💭": Color.blue.lightened(by: 0.2),
                "🦋": .blue
                ]),
            rows: [
                "🦋🦋🦋🦋🦋",
                "🦋🦋💭🦋🦋",
                "🦋💭🦋💭🦋",
                "🦋🦋🦋🦋🦋",
                "🦋🦋🦋🦋🦋"
            ]
        )
    }

    struct Player: Sprite {
        private typealias `Self` = Player

        enum Heading {
            case up
            case left
            case down
            case right
        }

        private let cellSize = Size(width: 5, height: 5)

        var heading: Heading
        var boardPosition: Point
        var position: Point {
            return Point(x: boardPosition.x * cellSize.width, y: boardPosition.y * cellSize.height)
        }
        let mode: Shape.Mode = .clip

        var shape: Shape {
            switch heading {
            case .up:
                return Self.upShape
            case .left:
                return Self.leftShape
            case .down:
                return Self.downShape
            case .right:
                return Self.rightShape
            }
        }

        static func heading(for landscapeCharacter: Character) -> Heading? {
            switch landscapeCharacter {
            case "⬆️": return .up
            case "⬅️": return .left
            case "⬇️": return .down
            case "➡️": return .right
            default:
                return nil
            }
        }

        static let upShape = Shape(
            rows: [
                "❔❔🍊❔❔",
                "❔🍏🍊🍏❔",
                "❔🍏🍊🍏❔",
                "❔🍏🍏🍏❔",
                "❔❔❔❔❔"
            ]
        )

        static let leftShape = Shape(
            rows: [
                "❔❔❔❔❔",
                "❔🍏🍏🍏❔",
                "🍊🍊🍊🍏❔",
                "❔🍏🍏🍏❔",
                "❔❔❔❔❔"
            ]
        )

        static let downShape = Shape(
            rows: [
                "❔❔❔❔❔",
                "❔🍏🍏🍏❔",
                "❔🍏🍊🍏❔",
                "❔🍏🍊🍏❔",
                "❔❔🍊❔❔"
            ]
        )

        static let rightShape = Shape(
            rows: [
                "❔❔❔❔❔",
                "❔🍏🍏🍏❔",
                "❔🍏🍊🍊🍊",
                "❔🍏🍏🍏❔",
                "❔❔❔❔❔"
            ]
        )
    }

    enum FloatingCellValue: CellValue {
        private typealias `Self` = FloatingCellValue

        case gem

        var shape: Shape {
            switch self {
            case .gem:
                return Self.gemShape
            }
        }

        static func tile(for c: Character) -> FloatingCellValue? {
            switch c {
            case "❤️": return .gem
            default:
                return nil
            }
        }

        static let gemShape = Shape(
            colors:
            ColorTable([
                "❔": nil,
                "❤️": Color.red.withAlphaComponent(0.8)
                ]),
            rows: [
                "❔❔❔❔❔",
                "❔❔❤️❔❔",
                "❔❤️❤️❤️❔",
                "❔❔❤️❔❔",
                "❔❔❔❔❔"
            ]
        )
    }

    public struct Landscape {
        public var rows: [String]
    }
}

extension SwiftLesson {
    private func delay(_ timeInterval: TimeInterval = 1) {
        Thread.sleep(until: Date(timeIntervalSinceNow: timeInterval))
    }

    public func moveForward() {
        defer { delay() }
        print("moveForward")

        player.boardPosition.x += 1
    }

    private var hasGem: Bool {
        return floatingLayer[player.boardPosition] == .gem
    }

    public func collectGem() {
        defer { delay() }
        print("collectGem")

        guard hasGem else { return }
        floatingLayer[player.boardPosition] = nil
        gemCount -= 1
    }
}
