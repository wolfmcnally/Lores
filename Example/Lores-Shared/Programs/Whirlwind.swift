import Lores
import func WolfCore.easeIn

class WhirlwindProgram: Program {
    private struct Particle {
        var center: DPoint = .zero
        var radius: Double = 0
        var angle: Double = 0
        var angularSpeed: Double = 0
        var color: Color = .white
    }

    private let particlesCount = 4000
    private var particles = [Particle]()
    private var center = DPoint.zero

    override func setup() {
        framesPerSecond = 60
        canvasSize = Size(width: 350, height: 200)
        backgroundCanvas.clearColor = .clear
        center = canvas.bounds.mid.dpoint
        for _ in 0 ..< particlesCount {
            particles.append(makeParticle())
        }
    }

    override func update() {
        for i in 0 ..< particles.count {
            particles[i].angle += particles[i].angularSpeed
        }
    }

    override func draw() {
        for p in particles {
            let x = Int(p.center.x + cos(p.angle) * p.radius + 0.5)
            let y = Int(p.center.y + sin(p.angle) * p.radius + 0.5)
            let point = DPoint(x: x, y: y).point
            guard canvas.isValidPoint(point) else { continue }
            canvas[point] = p.color
        }
    }

    private func makeParticle() -> Particle {
        var p = Particle()

        p.center = canvas.bounds.mid.dpoint

        let minRadius = Double(canvas.bounds.maxX) / 20
        let maxRadius = Double(canvas.bounds.maxX) / 1.5
        p.radius = Random.number(minRadius .. maxRadius)

        p.angle = Random.number(0 .. (2 * .pi))

        let minSteps = 800.0
        let maxSteps = 1200.0
        p.angularSpeed = .pi * 2 / Random.number(minSteps .. maxSteps)

        let minSpeed = 1.0
        let maxSpeed = 4.0
        p.angularSpeed *= p.radius.lerped(from: minRadius .. maxRadius, to: maxSpeed .. minSpeed)

        let minAngSpeed = .pi * 2 / maxSteps * minSpeed
        let maxAngSpeed = .pi * 2 / minSteps * maxSpeed

        let baseHue = 0°
        let hueOffset = 40°
        let hue: Frac
        switch Random.boolean() {
        case false:
            hue = baseHue / 360°
        case true:
            hue = (baseHue + hueOffset) / 360°
        }
        let saturation = Random.number(0.8 .. 1.0)
        let minBrightness = 0.2
        let maxBrightness = 1.0
        let brightness = easeIn(p.angularSpeed.lerped(from: maxAngSpeed .. minAngSpeed, to: minBrightness .. maxBrightness))

        p.color = Color(hue: hue, saturation: saturation, brightness: brightness)

        return p
    }
}
