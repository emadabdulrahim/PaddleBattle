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
    
    
    let playerConfigs = [
        ["playerPosition" : PlayerPosition.Left,   "paddle" : 90,  "goal" : 90, "color" : "blue",  "position" : ["x": 195, "y": 150]],
        ["playerPosition" : PlayerPosition.Right,  "paddle" : -90, "goal" : 90, "color" : "red",   "position" : ["x": 115, "y": 150]],
        ["playerPosition" : PlayerPosition.Bottom, "paddle" : 0,   "goal" : 0,  "color" : "pink",  "position" : ["x": 150, "y": 195]],
        ["playerPosition" : PlayerPosition.Top,    "paddle" : 180, "goal" : 0,  "color" : "green", "position" : ["x": 150, "y": 115]],
    ]
    
    
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
    
    func setupPlayer(index : Int) {
        let config = playerConfigs[index]
        let color = config["color"] as! String
        
        playerPosition = config["playerPosition"] as! PlayerPosition
        player.paddle.rotation = config["paddle"] as! Float
        circle.name = color
        player.name = color
        circle.spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/circles/circle-\(color).png")
        player.paddle.spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/paddles/paddle-\(color).png")
        goal.rotation = config["goal"] as! Float
        goal.position =  CGPoint(x: config["x"] as! CGFloat, y: config["y"] as! CGFloat)
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
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) { }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if gameStatus == .Running {
            if !didLose {
                rotatePaddle(touch)
            }
            previousTouch = touch.locationInNode(self)
        }
    }
    
    
    private func rotatePaddle(touch: CCTouch) {
        let touchLocation = touch.locationInNode(self)
        var delta : CGFloat
        
        switch player.paddle.color {
        case "green":
            delta = -(touchLocation.x - previousTouch.x)
        case "pink":
            delta = (touchLocation.x - previousTouch.x)
        case "blue":
            delta = -(touchLocation.y - previousTouch.y)
        case "red":
            delta = (touchLocation.y - previousTouch.y)
        default:
            break
        }
        
        delta = min(4, delta)
        delta = max(-4, delta)
        var result = player.rotation + Float(delta)
        result = min(maxRotation, result)
        result = max(-maxRotation, result)
        player.rotation = result
    }
}