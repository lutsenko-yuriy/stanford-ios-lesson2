//
//  ViewController.swift
//  SetGame
//
//  Created by Yuriy Lutsenko on 06/01/2019.
//  Copyright © 2019 Yuriy Lutsenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OnGameStateUpdatedDelegate {
    
    let model = SetGameInteractor()
    
    @IBOutlet weak var scoresLabel: UILabel!
    
    @IBOutlet var cards: [UIButton]!
    
    @IBAction func onNewGamePressed(_ sender: UIButton) {
        model.reset()
    }
    
    @IBAction func onAddMoreCardsPressed(_ sender: UIButton) {
        model.addMoreCards()
    }
    
    func onUpdated(withGameState gameState: SetGameInteractor.GameState) {
        switch gameState {
        case .IncompleteSelection(let playboard, let scoreCount):
            displayScores(scoreCount.score)
        case .SuccessSelection(let playboard, let scoreCount):
            displayScores(scoreCount.score)
        case .FailureSelection(let playboard, let scoreCount):
            displayScores(scoreCount.score)
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

