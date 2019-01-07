//
//  Card.swift
//  SetGame
//
//  Created by Yuriy Lutsenko on 06/01/2019.
//  Copyright © 2019 Yuriy Lutsenko. All rights reserved.
//

import Foundation

// We don't know what particular colors, shapes etc. should be
enum Color : CaseIterable {
    case color1, color2, color3
}

enum Number : CaseIterable {
    case number1, number2, number3
}

enum Shape : CaseIterable {
    case shape1, shape2, shape3
}

enum Shading : CaseIterable {
    case shading1, shading2, shading3
}

struct Card : Hashable {
    let color: Color
    let number: Number
    let shape: Shape
    let shading: Shading
}

struct CardState {
    let card: Card
    var isSelected: Bool
}
