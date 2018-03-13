//
//  ColorTable.swift
//  Lores
//
//  Created by 🐺 McNally on 3/8/18.
//

public struct ColorTable {
    public var colors: [Character: Color?] = [:]

    public init(_ colors: [Character: Color?]) {
        self.colors = colors
    }

    public subscript(c: Character) -> Color? {
        get { return colors[c]! }
        set { colors[c] = newValue }
    }

    public static let standardColors = ColorTable([
        "❔": nil,
        "⚪️": .clear,
        "💣": .black,
        "💭": .white,
        "🐺": .gray,
        "❤️": .red,
        "🍊": .orange,
        "🍋": .yellow,
        "🍏": .green,
        "🦋": .blue,
        "🍇": .purple,
        "🌸": .pink,
        "🐻": .brown
    ])
}
