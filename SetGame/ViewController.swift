//
//  ViewController.swift
//  SetGame
//
//  Created by Yuriy Lutsenko on 06/01/2019.
//  Copyright © 2019 Yuriy Lutsenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OnGameStateUpdatedDelegate {
    
    lazy var model = SetGameInteractor(withCountOfCards: cardsButtons.count)
    
    @IBOutlet weak var scoresLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    var cardsArray = [CardState?]()
    
    @IBOutlet var cardsButtons: [UIButton]!
    
    @IBAction func onNewGamePressed(_ sender: UIButton) {
        model.reset()
    }
    
    @IBAction func onAddMoreCardsPressed(_ sender: UIButton) {
        model.addMoreCards()
    }
    
    @IBAction func onCardSelection(_ sender: UIButton) {
        if let index = cardsButtons.index(of: sender), let card = cardsArray[index] {
            model.select(card: card.card)
        }
    }
    
    func onUpdated(withGameState gameState: GameState) {
        cardsArray = gameState.cards
        displayScores(gameState.score)
        
        newGameButton.isEnabled = gameState.cardsAvailableForLoading
        
        switch gameState.selectionState {
        case .FailureSelection:
            showState(circleSelectedInColor: #colorLiteral(red: 1, green: 0, blue: 0.03492087608, alpha: 1))
        case .IncompleteSelection:
            showState(circleSelectedInColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
        case .SuccessSelection:
            showState(circleSelectedInColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
        }
    }
    
    private func showState(circleSelectedInColor color: UIColor) {
        for i in cardsArray.indices {
            if let cardState = cardsArray[i] {
                cardsButtons[i].setAttributedTitle(buildText(for: cardState.card), for: UIControl.State.normal)
                cardsButtons[i].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                if cardState.isSelected {
                    cardsButtons[i].layer.borderColor = color.cgColor
                    cardsButtons[i].layer.borderWidth = 3.0
                } else {
                    cardsButtons[i].layer.borderColor = color.cgColor
                    cardsButtons[i].layer.borderWidth = 0
                }
            } else {
                cardsButtons[i].backgroundColor = self.view.backgroundColor
                cardsButtons[i].setAttributedTitle(nil, for: UIControl.State.normal)
                cardsButtons[i].layer.borderColor = color.cgColor
                cardsButtons[i].layer.borderWidth = 0
            }
        }
    }
    
    private func buildText(for card: Card) -> NSAttributedString {
        let string = String(repeating: shape(for: card.shape), count: times(for: card.number))
        let attributes: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.strokeColor : color(for: card.color).withAlphaComponent(shading(for: card.shading)),
            NSAttributedString.Key.strokeWidth : 12
        ]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    private func shape(for value: Shape) -> String {
        switch value {
        case .shape1:
            return "▲"
        case .shape2:
            return "●"
        case .shape3:
            return "■"
        }
    }
    
    private func times(for value: Number) -> Int {
        switch value {
        case .number1:
            return 1
        case .number2:
            return 2
        case .number3:
            return 3
        }
    }
    
    private func color(for value: Color) -> UIColor {
        switch value {
        case .color1:
            return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case .color2:
            return #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        case .color3:
            return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }
    }
    
    private func shading(for value: Shading) -> CGFloat {
        switch value {
        case .shading1:
            return CGFloat(0.3333)
        case .shading2:
            return CGFloat(0.6667)
        case .shading3:
            return CGFloat(1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        model.delegate = self
    }
    
    private func displayScores(_ scores: Int) {
        scoresLabel.text = "Scores: \(scores)"
    }
    
}

