//
//  Ball.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Ball: CCSprite {
    
    enum BallCorner {
        case BottomLeft
        case BottomRight
        case TopLeft
        case TopRight
    }
    
    let maxSpeed = CGFloat(600)
    let minSpeed = CGFloat(250)
    let ballLocation : CGFloat = 40
    var ballCorner : BallCorner = .BottomLeft
    
    weak var gameScene : MainScene?
    //    add trail particle effect to the ball
    
    func addTrail() {
        let trail = CCBReader.load("Trail") as! CCParticleSystem
        trail.name = "trail"
        trail.position = CGPoint(x: contentSizeInPoints.width/2, y: contentSizeInPoints.height/2)
        trail.particlePositionType = CCParticleSystemPositionType.Free
        self.addChild(trail)
        trail.zOrder = -1
    }
    
    func addBallAndApplyImpulse(speed: CGFloat) {
        var velocityX = CGFloat(arc4random_uniform(6) + 18)
        var velocityY = CGFloat(arc4random_uniform(6) + 5)
        gameScene?.gamePhysicsNode.addChild(self)
        switch ballCorner {
        case .BottomLeft:
            physicsBody.applyImpulse(CGPoint(x: velocityX * speed, y: velocityY * speed))
        case .BottomRight:
            physicsBody.applyImpulse(CGPoint(x: -velocityX * speed, y: velocityY * speed))
        case .TopLeft:
            physicsBody.applyImpulse(CGPoint(x: velocityX * speed, y: -velocityY * speed))
        case .TopRight:
            physicsBody.applyImpulse(CGPoint(x: -velocityX * speed, y: -velocityY * speed))
        }
        gameScene?.balls.append(self)
        GameSound.sharedInstance.playSound(GameSettings.spawnSound, volume: 1.0)
    }
    
    func spawnBallAtLocation(corner: UInt32) {
        if let gameScene = gameScene {
            var ballPosition : CGPoint
            switch corner {
            case 1:
                ballPosition = CGPoint(x: ballLocation, y: ballLocation)
                ballCorner = .BottomLeft
            case 2:
                ballPosition = CGPoint(x: gameScene.contentSizeInPoints.width - ballLocation, y: ballLocation)
                ballCorner = .BottomRight
            case 3:
                ballPosition = CGPoint(x: ballLocation, y: gameScene.contentSizeInPoints.height - ballLocation)
                ballCorner = .TopLeft
            case 4:
                ballPosition = CGPoint(x: gameScene.contentSizeInPoints.width - ballLocation, y: gameScene.contentSizeInPoints.height - ballLocation)
                ballCorner = .TopRight
            default:
                ballPosition = CGPointZero
            }
            
            position = ballPosition
        }
    }
    
    func limitBallSpeed() {
        //       Clamp the speed of the ball manually between Min and Max Speed values
//        println("Ball speed \(ccpLength(physicsBody.velocity))")
        if ccpLength(physicsBody.velocity) > maxSpeed {
            println("TOO FAST")
            physicsBody.velocity = ccpMult(physicsBody.velocity, 0.8)
        } else if ccpLength(physicsBody.velocity) < minSpeed {
            println("TOO SLOW")
            physicsBody.velocity = ccpMult(physicsBody.velocity, 1.2)
        }

    }
    
    func unstuckBall() {
        //      if the ball get stuck on a certain path, give it impulse to unstuck it
        if physicsBody.velocity.y < 10 && physicsBody.velocity.y > -10 {
            physicsBody.velocity.y *= 25
        }
        
        if physicsBody.velocity.x < 10 && physicsBody.velocity.x > -10 {
            physicsBody.velocity.x *= 25
        }
        
    }
    
    override func update(delta: CCTime) {
        if let gameScene = gameScene {
            if gameScene.gamePhysicsNode.children != nil {
                for child in gameScene.gamePhysicsNode.children {
                    if let ball = child as? Ball {
                        if CGRectContainsPoint(gameScene.playBox.boundingBox(), position) {
                            limitBallSpeed()
                            unstuckBall()
                            
                            if let trail = getChildByName("trail", recursively: false) as? CCParticleSystem {
                                trail.startSize = Float(ccpLength(physicsBody.velocity)*0.03)
                            }
                            
                        } else {
                            removeFromParentAndCleanup(true)
                            if let index = find(gameScene.balls, self) {
                                gameScene.balls.removeAtIndex(index)
                            }
                            
                    //        always keep a ball in the play field
                            if gameScene.balls.count == 0 && gameStatus == .Running {
                                gameScene.runAction(CCActionSequence(array: [CCActionDelay(duration: 0.25), CCActionCallBlock(block: { () -> Void in
                                    gameScene.createNewBall()
                                })]))
                            }
                        }
                    }
                }
            }
        }
        
    }
}
