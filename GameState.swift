//
//  GameState.swift
//  SetGame
//
//  Created by Yuriy Lutsenko on 08/01/2019.
//  Copyright © 2019 Yuriy Lutsenko. All rights reserved.
//

import Foundation

struct GameState {
    let cards: [CardState?]
    let score: Int
    let cardsAvailableForLoading: Bool
    let selectionState: SelectionState
}

enum SelectionState {
    case IncompleteSelection
    case SuccessSelection
    case FailureSelection
}
