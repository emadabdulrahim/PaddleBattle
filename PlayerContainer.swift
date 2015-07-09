//
//  PlayerContainer.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

var deadPlayerCounter : Int = 0

import Foundation

class PlayerContainer : CCNode {
    
    weak var player : Player!
    weak var goal : Goal!
    weak var circle : CCSprite!
    var scoreManager : Score!
    
    var score : Int = 5 {
        didSet {
            // update label
            // label.string = score
            if score >= 0 {
                scoreManager.minusScore(score)
            }
            
            if score == 0 {
                player.eliminatePlayer()
            }
        }
    }
    
    func didLoadFromCCB() {
        
        
        scoreManager = CCBReader.load("Score") as! Score
        scoreManager.setupScoreForPlayer(player.playerPosition, numberOfPoints: score)
        
    }
    
    override func update(delta: CCTime) {
    
    }
}