//
//  CardSet.swift
//  SetGame
//
//  Created by Yuriy Lutsenko on 06/01/2019.
//  Copyright © 2019 Yuriy Lutsenko. All rights reserved.
//

import Foundation

class SetGameInteractor {
    
    
    private var currentState: GameState {
        didSet {
            delegate?.onUpdated(withGameState: currentState)
        }
    }
    
    weak var delegate: OnGameStateUpdatedDelegate! {
        didSet {
            
        }
    }
    
    private static let INITIAL_SET_GAME_CARD_COUNT = 12
    private static let ADDITIONAL_SET_GAME_CARD_COUNT = 3
    
    private let correctnessVerifier =
        SetCorrectnessVerifier()
    
    private var cardStack = CardStack()
    
    init() {
        cardStack.resetStack()
        currentState = GameState.IncompleteSelection(Playboard(), ScoreCounter())
    }
    
    func reset() {
        cardStack.resetStack()
        currentState = GameState.IncompleteSelection(Playboard(), ScoreCounter())
    }
    
    func addMoreCards() {
        let newCards = cardStack.nextCards(count: SetGameInteractor.ADDITIONAL_SET_GAME_CARD_COUNT)
        switch currentState {
        case .IncompleteSelection(let playboard, let scoreCounter):
            currentState = .IncompleteSelection(playboard.fillWith(newItems: newCards), scoreCounter)
        case .SuccessSelection(let playboard, let scoreCounter):
            currentState = .SuccessSelection(playboard.fillWith(newItems: newCards), scoreCounter)
        case .FailureSelection(let playboard, let scoreCounter):
            currentState = .IncompleteSelection(playboard.fillWith(newItems: newCards), scoreCounter)
        }
    }
    
    func select(card: Card) {
        switch currentState {
        case .IncompleteSelection(let playboard, var scoreCounter):
            let newPlayboard = playboard.select(card: card)
            let selectedCards = newPlayboard.selectedCards
            // The card was deselected therefore there cannot be card
            if !selectedCards.contains(card) {
                currentState = .IncompleteSelection(newPlayboard, scoreCounter.onDeselect())
                break
            }
            if correctnessVerifier.isCardsSelectionCorrect(cards: selectedCards) {
                currentState = .SuccessSelection(newPlayboard, scoreCounter.onSetCorrect())
            } else {
                currentState = .FailureSelection(newPlayboard, scoreCounter.onSetIncorrect())
            }
        case .SuccessSelection(let playboard, let scoreCounter):
            currentState = .IncompleteSelection(playboard.resetSelection(afterSuccess: true), scoreCounter)
        case .FailureSelection(let playboard, let scoreCounter):
            currentState = .IncompleteSelection(playboard.resetSelection(), scoreCounter)
        }
    }
    
    enum GameState {
        case IncompleteSelection(Playboard, ScoreCounter)
        case SuccessSelection(Playboard, ScoreCounter)
        case FailureSelection(Playboard, ScoreCounter)
    }
}
