//
//  Score.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Score: CCNode {

    weak var scorePoint1 : CCSprite!
    weak var scorePoint2 : CCSprite!
    weak var scorePoint3 : CCSprite!
    weak var scorePoint4 : CCSprite!
    weak var scorePoint5 : CCSprite!
    var scorePointArray = [CCSprite]()
    var playerColor : String!

    func didLoadFromCCB() {
        scorePointArray = [scorePoint1, scorePoint2, scorePoint3, scorePoint4, scorePoint5]
    }
    
    func setupScoreImageColor(colorName: String) {
//        if children != nil {
            for child in children {
                if let scorePoint = child as? CCSprite {
                    scorePoint.spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/score-pieces/score-piece-\(colorName)-active.png")
                    playerColor = colorName
                }
            }
//        }
    }
    
    func setupScoreForPlayer(playerPosition: PlayerPosition, numberOfPoints: Int) {
        switch playerPosition {
        case .Top:
            setupScoreImageColor("red")
            rotation = 315
        case .Bottom:
            setupScoreImageColor("red")
            rotation = 135
        case .Left:
            setupScoreImageColor("red")
            rotation = 225
        case .Right:
            setupScoreImageColor("red")
            rotation = 45
        }
        
    }
    
    
    func minusScore(score: Int) {
        let disabledFrame = CCSpriteFrame(imageNamed: "Paddle Battle/score-pieces/score-piece-\(self.playerColor)-disabled.png")
        scorePointArray[score].runAction(CCActionSequence(array: [CCActionBlink(duration: 0.2, blinks: 2), CCActionSpriteFrame(spriteFrame: disabledFrame)]) )
    }
    
}
