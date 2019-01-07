//
//  SetCorrectnessVerifier.swift
//  SetGame
//
//  Created by Yuriy Lutsenko on 06/01/2019.
//  Copyright © 2019 Yuriy Lutsenko. All rights reserved.
//

import Foundation

class SetCorrectnessVerifier {
    
    func isCardsSelectionCorrect(card1: Card, card2: Card, card3: Card) -> Bool {
        return [card1, card2, card3].satisfiesSetRules()
    }
    
    func isCardsSelectionCorrect(cards: [Card]) -> Bool {
        return cards.satisfiesSetRules()
    }
}

extension Collection where Element == Card {
    
    func satisfiesSetRules() -> Bool {
        let correctColors = Set(self.map { $0.color }).count != 2
        let correctNumbers = Set(self.map { $0.number }).count != 2
        let correctShapes = Set(self.map { $0.shape }).count != 2
        let correctShadings = Set(self.map { $0.shading }).count != 2
        
        return self.count == 3 && correctColors && correctNumbers && correctShapes && correctShadings
    }
    
}
