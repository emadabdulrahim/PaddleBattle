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
    weak var goal : CCNode!
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
        
        goal.physicsBody.sensor = true
    }
    
    func setupPlayer() {
        if name == "player1" {
            playerPosition = .Left
            player.paddle.rotation = 90
            circle.name = "blue"
            circle.spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/circles/circle-blue.png")
            player.paddle.spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/paddles/paddle-blue.png")
            goal.rotation = 90
            goal.position = CGPoint(x: 195, y: 150)

        }
        
        if name == "player2" {
            playerPosition = .Right
            player.paddle.rotation = -90
            circle.name = "red"
            circle.spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/circles/circle-red.png")
            player.paddle.spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/paddles/paddle-red.png")
            goal.rotation = 90
            goal.position = CGPoint(x: 115, y: 150)
        }
        if name == "player3" {
            playerPosition = .Bottom
            player.paddle.rotation = 0
            circle.name = "pink"
            circle.spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/circles/circle-pink.png")
            player.paddle.spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/paddles/paddle-pink.png")
            goal.position = CGPoint(x: 150, y: 195)
        }
        
        if name == "player4" {
            playerPosition = .Top
            player.paddle.rotation = 180
            circle.name = "green"
            circle.spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/circles/circle-green.png")
            player.paddle.spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/paddles/paddle-green.png")
            goal.position = CGPoint(x: 150, y: 115)
        }
        
        setupPlayerScore()
    }
    
    func setupPlayerScore() {
        if score == 0 {
            return
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