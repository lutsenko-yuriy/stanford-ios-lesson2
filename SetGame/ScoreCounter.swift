//
//  ScoreCounter.swift
//  SetGame
//
//  Created by Yuriy Lutsenko on 06/01/2019.
//  Copyright © 2019 Yuriy Lutsenko. All rights reserved.
//

import Foundation

class ScoreCounter {
    
    private(set) var score = 0
    
    func onSetCorrect() -> ScoreCounter {
        score += 3
        return self
    }
    
    func onSetIncorrect() -> ScoreCounter {
        score -= 5
        return self
    }
    
    func onDeselect() -> ScoreCounter {
        score -= 1
        return self
    }
    
}
