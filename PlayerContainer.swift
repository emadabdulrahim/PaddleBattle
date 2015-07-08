//
//  PlayerContainer.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

var gameEnded = false
var deadPlayerCounter : Int = 0

import Foundation

class PlayerContainer : CCNode {
    
    weak var player : Player!
    weak var goal : Goal!
    weak var circle : CCSprite!
    var scoreManager : Score!
    
    var score : Int = 1 {
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
    
//    func removePlayer() {
//        if player.playerAlive == true {
//            for child in children {
//                if let thisPlayer = child as? Player {
//                    thisPlayer.playerAlive = false
//                    removeChild(thisPlayer, cleanup: true)
//                } else if let circle = child as? CCSprite {
//                    circle.removeFromParentAndCleanup(true)
//                } else if let goal = child as? Goal {
//                    runAction(CCActionSequence(array: [CCActionDelay(duration: 0.5), CCActionCallBlock(block: { () -> Void in
//                        goal.physicsBody.sensor = false
//                    })]))
//                }
//            }
//            deadPlayerCounter++
//        }
//        
//    }
    
    override func update(delta: CCTime) {
    
    }
}