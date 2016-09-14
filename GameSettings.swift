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

let Debug = false

var deadPlayerCounter = 0


struct GameSettings {
    
    static let spawnSound = "Sound design magical accent wand pixie dust science fiction 01_SFXBible_ss02338.mp3"
    static let paddleHitSound = "FOLEY RUBBER BALL BOUNCE HARD SINGLE 01.mp3"
    static let hitSound = "FOLEY RUBBER BALL BOUNCE SINGLE 01.mp3"
    static var hardMode = false
    static var numberOfPlayers  = 4
    static var activePlayers = 4
//    static var teamPlay = false
    
}

func DebugLog(message: String) {
    if Debug {
        println(message)
    }
}