//
//  Player.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

enum PlayerPosition {
    case Top
    case Bottom
    case Left
    case Right
}


import Foundation

class Player: CCSprite {
    
    
    let maxRotation : Float = 45.0
    var previousTouch = CGPointZero
    weak var paddle : Paddle!
    var playerPosition : PlayerPosition = .Bottom
    var didLose = false
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        multipleTouchEnabled = true
        loadPaddleColors()
    }
    
    func loadPaddleColors() {
        if (children != nil) {
            for child in children {
                if let paddle = child as? Paddle {
                    let spriteFrame = CCSpriteFrame(imageNamed: "Paddle Battle/paddles/paddle-\(paddle.name).png")
                    paddle.imageNode.spriteFrame = spriteFrame
                    
                    if paddle.name == "pink" {
                        playerPosition = .Left
                    }
                    if paddle.name == "red" {
                        playerPosition = .Right
                    }
                    if paddle.name == "green" {
                        playerPosition = .Top
                    }
                }
            }
        }
    }
    
    override func onEnterTransitionDidFinish() {
        if didLose {
            eliminatePlayer()
        }
    }
    
//
    func eliminatePlayer() {
        didLose = true
        deadPlayerCounter++
        stopAllActions()
        userInteractionEnabled = false
        multipleTouchEnabled = false
        runAction(CCActionSequence(array: [CCActionRotateBy(duration: 1.25, angle: 180), CCActionCallBlock(block: { () -> Void in
            let playerContainer = self.parent as! PlayerContainer
            playerContainer.goal.physicsBody.sensor = false
        })]))
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if gameStatus == .Starting {
            if !didLose {
                stopAllActions()
                runAction(CCActionSequence(array: [CCActionRotateBy(duration: 1.25, angle: 180), CCActionCallBlock(block: { () -> Void in
                })]))
                didLose = true
            } else {
                stopAllActions()
                runAction(CCActionRotateTo(duration: 0.25, angle: 0))
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
            var oldRotation = rotation
            var result = rotation + Float(delta)
            result = min(maxRotation, result)
            result = max(-maxRotation, result)
            rotation = result
        }
        
    }
}
