//
//  Shape.swift
//  Lores
//
//  Created by 🐺 McNally on 3/8/18.
//

public protocol Shape {
    var colors: ColorTable { get set }
    var offset: Offset { get set }
    var rows: [String] { get set }
}

//
// Example:
//
//    struct SmallHeart: Shape {
//        var colors = standardColors
//        var offset = Offset(dx: 2, dy: 1)
//        var rows = [
//            "❔❤️❔❤️❔",
//            "❤️❤️❤️❤️❤️",
//            "❔❤️❤️❤️❔",
//            "❔❔❤️❔❔"
//        ]
//    }
//
