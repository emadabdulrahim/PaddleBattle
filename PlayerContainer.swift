//
//  PlayerContainer.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


enum PlayerPosition {
    case Top
    case Bottom
    case Left
    case Right
}


import Foundation

class PlayerContainer : CCNode {
    
    weak var player : Player!
    weak var goal : Goal!
    weak var circle : CCSprite!
    var scoreManager : Score!
    let maxRotation : Float = 45.0
    var previousTouch = CGPointZero
    var playerPosition : PlayerPosition = .Bottom
    var didLose = false


    var score : Int = 5 {
        didSet {
            // update label
            // label.string = score
            if score >= 0 {
                scoreManager.minusScore(score)
            }
            
            if score == 0 {
                eliminatePlayer()
            }
        }
    }
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        multipleTouchEnabled = true
        
        let spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/paddles/paddle-\(player.name).png")
        player.paddle.spriteFrame = spriteFrame
        
        if player.name == "pink" {
            playerPosition = .Left
            player.paddle.rotation = 90
        }
        if player.name == "red" {
            playerPosition = .Right
            player.paddle.rotation = -90
        }
        if player.name == "green" {
            playerPosition = .Top
            player.paddle.rotation = 180
        }
        
        scoreManager = CCBReader.load("Score") as! Score
        scoreManager.setupScoreForPlayer(playerPosition, numberOfPoints: score)
        
    }
    
    func eliminatePlayer() {
        didLose = true
        deadPlayerCounter++
        stopAllActions()
        userInteractionEnabled = false
        multipleTouchEnabled = false
        player.runAction(CCActionSequence(array: [CCActionRotateBy(duration: 0.75, angle: 180), CCActionCallBlock(block: { () -> Void in
            self.goal.physicsBody.sensor = false
        })]))
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if gameStatus == .Starting {
            if !didLose {
                player.stopAllActions()
                player.runAction(CCActionSequence(array: [CCActionRotateBy(duration: 1.00, angle: 180), CCActionCallBlock(block: { () -> Void in
                })]))
                didLose = true
            } else {
                player.stopAllActions()
                player.runAction(CCActionRotateTo(duration: 0.25, angle: 0))
                didLose = false
            }
        }
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if gameStatus == .Running {
            rotatePaddle(touch)
            previousTouch = touch.locationInNode(self)
        }
    }

    
    private func rotatePaddle(touch: CCTouch) {
        if !didLose {
            let touchLocation = touch.locationInNode(self)
            var delta : CGFloat
            switch playerPosition {
            case .Top:
                delta = -(touchLocation.x - previousTouch.x)
            case .Bottom:
                delta = (touchLocation.x - previousTouch.x)
            case .Left:
                delta = -(touchLocation.y - previousTouch.y)
            case .Right:
                delta = (touchLocation.y - previousTouch.y)
            }
            
            delta = min(4, delta)
            delta = max(-4, delta)
            var result = player.rotation + Float(delta)
            result = min(maxRotation, result)
            result = max(-maxRotation, result)
            player.rotation = result
        }
        
    }

}