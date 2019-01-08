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
        return cards.filter { $0?.isSelected == true }
            .map { $0!.card }
    }
    
    var isEmpty: Bool {
        return cards.allSatisfy { $0 == nil }
    }
    
    var isFull: Bool {
        return cards.allSatisfy { $0 != nil }
    }
    
    // Because I'm too lazy to add new items and stuff
    private(set) var cards = [CardState?](repeating: nil, count: 24)
    
    func reset() {
        cards = [CardState?](repeating: nil, count: 24)
    }
    
    func fillWith(newItems items: [Card]) -> Playboard {
        let emptyIndices =
            cards.indices
                .filter { cards[$0] == nil }
                .prefix(items.count)
        for i in 0..<min(emptyIndices.count, items.count) {
            cards[emptyIndices[i]] = CardState(card: items[i], isSelected: false)
        }
        return self
    }
    
    func select(card: Card) -> Playboard {
        if let index = cards.firstIndex(where: { $0?.card == card }) {
            let cardState = cards[index]!
            cards[index] = CardState(card: cardState.card, isSelected: !cardState.isSelected)
        }
        return self
    }
    
    func resetSuccessSelection() -> Playboard {
        cards = cards.map {
            if let cardState = $0, !cardState.isSelected {
                return CardState(card: cardState.card, isSelected: false)
            } else {
                return nil
            }
        }
        return self
    }
    
    func resetFailureSelection() -> Playboard {
        cards = cards.map {
            if let cardState = $0 {
                return CardState(card: cardState.card, isSelected: false)
            } else {
                return nil
            }
        }
        return self
    }
    
}
