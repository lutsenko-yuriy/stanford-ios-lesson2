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
    
    weak var delegate: OnGameStateUpdatedDelegate? {
        didSet {
            delegate?.onUpdated(withGameState: currentState)
        }
    }
    
    private let fullSetGameCardCount: Int
    private let initialSetGameCardCount: Int
    private let additionalSetGameCardCount = 3
    
    private let correctnessVerifier =
        SetCorrectnessVerifier()
    
    private var cardStack = CardStack()
    
    private var playboard: Playboard
    private var scoreCounter: ScoreCounter
    
    private var cardsAvailableForLoading: Bool {
        return !(playboard.isFull || cardStack.isEmpty)
    }
    
    init(withCountOfCards countOfCards: Int) {
        self.fullSetGameCardCount = countOfCards
        self.initialSetGameCardCount = fullSetGameCardCount / 2
        
        cardStack.resetStack()
        playboard = Playboard(withCountOfCards: fullSetGameCardCount).fillWith(newItems: cardStack.nextCards(count: initialSetGameCardCount))
        scoreCounter = ScoreCounter()
        currentState = GameState(
            cards: playboard.cards,
            score: scoreCounter.score,
            cardsAvailableForLoading: true,
            selectionState: .IncompleteSelection
        )
    }
    
    func reset() {
        cardStack.resetStack()
        playboard = Playboard(withCountOfCards: fullSetGameCardCount).fillWith(newItems: cardStack.nextCards(count: initialSetGameCardCount))
        scoreCounter = ScoreCounter()
        currentState = GameState(
            cards: playboard.cards,
            score: scoreCounter.score,
            cardsAvailableForLoading: self.cardsAvailableForLoading,
            selectionState: .IncompleteSelection
        )
    }
    
    func addMoreCards() {
        let newCards = cardStack.nextCards(count: additionalSetGameCardCount)
        playboard = playboard.fillWith(newItems: newCards)
        let scores = scoreCounter.score
        switch currentState.selectionState {
        case .IncompleteSelection:
            currentState = GameState(
                cards: playboard.cards,
                score: scores,
                cardsAvailableForLoading: self.cardsAvailableForLoading,
                selectionState: .IncompleteSelection
            )
        case .SuccessSelection:
            currentState = GameState(
                cards: playboard.resetSuccessSelection().cards,
                score: scores,
                cardsAvailableForLoading: self.cardsAvailableForLoading,
                selectionState: .SuccessSelection
            )
        case .FailureSelection:
            currentState = GameState(
                cards: playboard.resetSelection().cards,
                score: scores,
                cardsAvailableForLoading: self.cardsAvailableForLoading,
                selectionState: .SuccessSelection
            )
        }
    }
    
    func select(card: Card) {
        switch currentState.selectionState {
        case .IncompleteSelection:
            playboard = playboard.select(card: card)
            let selectedCards = playboard.selectedCards
            // The card was deselected therefore there cannot be card
            if !selectedCards.contains(card) {
                currentState = GameState(
                    cards: playboard.cards,
                    score: scoreCounter.onDeselect().score,
                    cardsAvailableForLoading: self.cardsAvailableForLoading,
                    selectionState: .IncompleteSelection
                )
            } else if selectedCards.count < 3 {
                currentState = GameState(
                    cards: playboard.cards,
                    score: scoreCounter.score,
                    cardsAvailableForLoading: self.cardsAvailableForLoading,
                    selectionState: .IncompleteSelection
                )
            } else if correctnessVerifier.isCardsSelectionCorrect(cards: selectedCards) {
                currentState = GameState(
                    cards: playboard.resetSuccessSelection().cards,
                    score: scoreCounter.onSetCorrect().score,
                    cardsAvailableForLoading: self.cardsAvailableForLoading,
                    selectionState: .IncompleteSelection
                )
            } else {
                currentState = GameState(
                    cards: playboard.cards,
                    score: scoreCounter.onSetIncorrect().score,
                    cardsAvailableForLoading: self.cardsAvailableForLoading,
                    selectionState: .FailureSelection
                )
            }
        case .SuccessSelection:
            currentState = GameState(
                cards: playboard.resetSuccessSelection().select(card: card).cards,
                score: scoreCounter.score,
                cardsAvailableForLoading: self.cardsAvailableForLoading,
                selectionState: .IncompleteSelection
            )
        case .FailureSelection:
            currentState = GameState(
                cards: playboard.resetSelection().select(card: card).cards,
                score: scoreCounter.score,
                cardsAvailableForLoading: self.cardsAvailableForLoading,
                selectionState: .IncompleteSelection
            )
        }
    }
    
}
