//
//  GameSettings.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum GameStatus {
    case Starting
    case Running
    case Paused
    case Ended
}

var deadPlayerCounter = 0


struct GameSettings {
    
    static var hardMode = false
    static var numberOfPlayers  = 4
    static var activePlayers = 4
//    static var teamPlay = false
}