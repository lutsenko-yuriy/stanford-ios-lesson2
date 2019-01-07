//
//  Playboard.swift
//  SetGame
//
//  Created by Yuriy Lutsenko on 06/01/2019.
//  Copyright © 2019 Yuriy Lutsenko. All rights reserved.
//

import Foundation

class Playboard {
    
    var selectedCards: [Card] {
        return setOfItems.filter { $0?.isSelected == true }
            .map { $0!.card }
    }
    
    var isEmpty: Bool {
        return setOfItems.allSatisfy { $0 == nil }
    }
    
    var isFull: Bool {
        return setOfItems.allSatisfy { $0 != nil }
    }
    
    // Because I'm too lazy to add new items and stuff
    private(set) var setOfItems = [CardState?](repeating: nil, count: 24)
    
    func reset() {
        setOfItems = [CardState?](repeating: nil, count: 24)
    }
    
    func fillWith(newItems items: [Card]) -> Playboard {
        let emptyIndices =
            setOfItems.indices
                .filter { setOfItems[$0] == nil }
                .prefix(items.count)
        for i in 0..<min(emptyIndices.count, items.count) {
            setOfItems[emptyIndices[i]] = CardState(card: items[i], isSelected: false)
        }
        return self
    }
    
    func select(card: Card) -> Playboard {
        if let index = setOfItems.firstIndex(where: { $0?.card == card }) {
            let cardState = setOfItems[index]!
            setOfItems[index] = CardState(card: cardState.card, isSelected: !cardState.isSelected)
        }
        return self
    }
    
    func resetSelection(afterSuccess: Bool = false) -> Playboard {
        setOfItems = setOfItems.map {
            if let cardState = $0, !afterSuccess {
                return CardState(card: cardState.card, isSelected: false)
            } else {
                return nil
            }
        }
        return self
    }
    
}
