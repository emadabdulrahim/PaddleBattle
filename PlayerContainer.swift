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
    weak var scoreLabel : CCLabelTTF!
    
    var score : Int = 4 {
        didSet {
            // update label
            // label.string = score
            scoreLabel.stopAllActions()
            scoreLabel.runAction(CCActionSequence(array: [CCActionScaleTo(duration: 0.15, scale: 1.15), CCActionScaleTo(duration: 0.15, scale: 1.0) ]))
            scoreLabel.string = String(score)
        }
    }
    
    func didLoadFromCCB() {
    }
    
    override func update(delta: CCTime) {
        if score == 0 {
            if let player = player.parent {
                player.removeFromParent()
                deadPlayerCounter++
                println(deadPlayerCounter)
            }
        }
        
        if deadPlayerCounter == 3 {
            gameEnded = true
        }
    }
}