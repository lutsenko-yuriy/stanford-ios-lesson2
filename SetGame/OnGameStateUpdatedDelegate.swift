//
//  OnGameStateUpdatedDelegate.swift
//  SetGame
//
//  Created by Yuriy Lutsenko on 07/01/2019.
//  Copyright © 2019 Yuriy Lutsenko. All rights reserved.
//

import Foundation

protocol OnGameStateUpdatedDelegate : class {
    func onUpdated(withGameState gameState: GameState)
}
