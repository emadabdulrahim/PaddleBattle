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
    
    
    weak var goal : Goal!
    let maxRotation : Float = 45.0
    var previousTouch = CGPointZero
    weak var paddle : Paddle!
    var playerPosition : PlayerPosition = .Bottom
    var playerAlive = true
    
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
                    paddle.spriteFrame = spriteFrame
                }
            }
        }
    }
    
    override func update(delta: CCTime) {
        if gameEnded == true {
            userInteractionEnabled = false
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        rotatePaddle(touch)
        previousTouch = touch.locationInNode(self)
    }
    
    private func rotatePaddle(touch: CCTouch) {
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
        
        delta = min(6, delta)
        delta = max(-6, delta)
        var oldRotation = rotation
        var result = rotation + Float(delta)
        result = min(maxRotation, result)
        result = max(-maxRotation, result)
        rotation = result
        
    }
}
