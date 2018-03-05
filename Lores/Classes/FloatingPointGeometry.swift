//
//  FloatingPointGeometry.swift
//  Lores
//
//  Created by 🐺 McNally on 3/4/18.
//

import WolfCore

public typealias DPoint = WolfCore.Point

extension DPoint {
    public var point: Point {
        return Point(x: Int(x), y: Int(y))
    }
}

public typealias DVector = WolfCore.Vector
public typealias Frac = WolfCore.Frac
