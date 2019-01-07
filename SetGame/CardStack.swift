//
//  CardStack.swift
//  SetGame
//
//  Created by Yuriy Lutsenko on 06/01/2019.
//  Copyright © 2019 Yuriy Lutsenko. All rights reserved.
//

import Foundation

class CardStack {
    
    var cardStack = [Card]()
    var stackTop = 0
    
    init() {
        for color in Color.allCases {
            for number in Number.allCases {
                for shape in Shape.allCases {
                    for shading in Shading.allCases {
                        cardStack.append(Card(color: color, number: number, shape: shape, shading: shading))
                    }
                }
            }
        }
    }
    
    func resetStack() {
        stackTop = 0
        cardStack.shuffle()
    }
    
    func nextCards(count: Int) -> [Card] {
        let newStackTop = stackTop + count
        let nextCards = Array(cardStack[stackTop..<newStackTop])
        stackTop = newStackTop
        return nextCards
    }

}
