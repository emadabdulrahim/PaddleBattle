import Foundation


class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    enum BallCorner {
        case BottomLeft
        case BottomRight
        case TopLeft
        case TopRight
    }
    
    weak var playerBot : PlayerContainer!
    weak var playerTop : PlayerContainer!
    weak var playerLeft : PlayerContainer!
    weak var playerRight : PlayerContainer!
    var players = [PlayerContainer]()
    weak var playBox : CCNode!
    weak var playerWonLabel : CCLabelTTF!
    weak var gamePhysicsNode : CCPhysicsNode!
    
    var balls = [Ball]()
    var gameTimer : NSTimer?
    var insanityTimer : NSTimer?
    var timeToStart : Int = 4
    var countdownLabel : CCLabelTTF!
    var restartButton : CCButton!
    var speed : CGFloat = 1
    let ballLocation : CGFloat = 40
    var ballCorner : BallCorner = .BottomLeft
    var ballTimeManager : CCTimer!
    var labelTimeManager : CCTimer!
    var difficultyTimer : CCTimer!
    
    let maxSpeed = CGFloat(500)
    
    
    
    func didLoadFromCCB() {
//        CCDirector.sharedDirector().displayStats = true
        userInteractionEnabled = true
        multipleTouchEnabled = true
//        gamePhysicsNode.debugDraw = true
        gamePhysicsNode.collisionDelegate = self
        gameEnded = false
        deadPlayerCounter = 0
        restartButton.visible = false
    }
    
    func setupCountDownLabel() {
        timeToStart--
        var labelText : String
        labelText = "\(timeToStart)"
        if timeToStart == 1 {
            labelText = "GO!"
        }
        countdownLabel.string = labelText
        
        var labelAction = CCActionSequence(array: [CCActionScaleBy(duration:0.4, scale: 1.5), CCActionEaseIn(action: CCActionFadeOut(duration: 0.4), rate: 2)])
        countdownLabel.runAction(labelAction)
        
        if timeToStart == 0 {
            self.removeChild(countdownLabel, cleanup: true)
        }
    }
    
    override func onEnterTransitionDidFinish() {
        playerBot.player.playerPosition = .Bottom
        playerTop.player.playerPosition = .Top
        playerLeft.player.playerPosition = .Left
        playerRight.player.playerPosition = .Right
        players = [playerBot, playerTop, playerLeft, playerRight]
        
        labelTimeManager = schedule("setupCountDownLabel", interval: 1, repeat: UInt(timeToStart), delay: 0)
        ballTimeManager = schedule("createNewBall", interval: 15, repeat: 99999, delay: CCTime(timeToStart))
        difficultyTimer = schedule("increaseDiffculty", interval: 35, repeat: 99999, delay: 35)
    }
    
    func increaseDiffculty() {
        speed *= 1.15
//        if velocityY > 400 || velocityX > 400 {
//            velocityX = 400
//            velocityY = 400
//        }
//        gameTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "createNewBall", userInfo: nil, repeats: true)
    }
    
    func setupSpawnParticle(location: CGPoint) {
        let smoke = CCBReader.load("Spawn") as! CCParticleSystem
        smoke.autoRemoveOnFinish = true
        smoke.position = location
//        println(smoke.position)
        addChild(smoke)
    }
    
    func createNewBall() {
        var ball = CCBReader.load("Ball") as! Ball
        var randomCorner = arc4random_uniform(4) + 1
        var velocityX = CGFloat(arc4random_uniform(6) + 18)
        var velocityY = CGFloat(arc4random_uniform(6) + 5)
        ball.position = spawnBallAtLocation(randomCorner)
        ball.name = "ball"
        println(ball.position)
        gamePhysicsNode.addChild(ball)
        switch ballCorner {
        case .BottomLeft:
            ball.physicsBody.applyImpulse(CGPoint(x: velocityX * speed, y: velocityY * speed))
        case .BottomRight:
            ball.physicsBody.applyImpulse(CGPoint(x: -velocityX * speed, y: velocityY * speed))
        case .TopLeft:
            ball.physicsBody.applyImpulse(CGPoint(x: velocityX * speed, y: -velocityY * speed))
        case .TopRight:
            ball.physicsBody.applyImpulse(CGPoint(x: -velocityX * speed, y: -velocityY * speed))
        }
        ball.physicsBody.allowsRotation = false
        balls.append(ball)
        println("ball speed \(ball.physicsBody.velocity)")
        addTrail(ball)
        
    }
    
//    add particle effect to the ball
    func addTrail(ball: Ball) {
        let trail = CCBReader.load("Trail") as! CCParticleSystem
        trail.position = CGPoint(x: ball.contentSizeInPoints.width/2, y: ball.contentSizeInPoints.height/2)
        trail.particlePositionType = CCParticleSystemPositionType.Free
        ball.addChild(trail)
        trail.zOrder = -1
    }
    
    func spawnBallAtLocation(corner: UInt32) -> CGPoint {
        var ballPosition : CGPoint
        switch corner {
        case 1:
            ballPosition = CGPoint(x: ballLocation, y: ballLocation)
            ballCorner = .BottomLeft
        case 2:
            ballPosition = CGPoint(x: contentSizeInPoints.width - ballLocation, y: ballLocation)
            ballCorner = .BottomRight
        case 3:
            ballPosition = CGPoint(x: ballLocation, y: contentSizeInPoints.height - ballLocation)
            ballCorner = .TopLeft
        case 4:
            ballPosition = CGPoint(x: contentSizeInPoints.width - ballLocation, y: contentSizeInPoints.height - ballLocation)
            ballCorner = .TopRight
        default:
            ballPosition = CGPointZero
        }
        setupSpawnParticle(ballPosition)
        return ballPosition
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, goal nodeA: Goal!, ball nodeB: Ball!) -> ObjCBool {
        println("Collision Happened")
        if let playerContainer = nodeA.parent as? PlayerContainer {
            playerContainer.score--
        }
        return true
    }
    
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, paddle nodeA: Paddle!, ball nodeB: Ball!) {
        println("Paddle Hit")
        let energy = pair.totalKineticEnergy
        if let player = nodeA.parent as? Player {
            if energy > 100 {
                shakePaddle(player)
            }
        }
    }
    
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, edge nodeA: CCPhysicsNode!, ball nodeB: Ball!) {
        let energy = pair.totalKineticEnergy
        println("energy \(CGFloat(energy))")
//        if energy > 5 {
        let spark = CCBReader.load("Spark") as! CCParticleSystem
        spark.position = nodeB.position
        spark.particlePositionType = CCParticleSystemPositionType.Free
        addChild(spark)
//        }
    }
    
    func shakePaddle(player: Player) {
        var shakeAction = CCActionRepeat(action: CCActionSequence(array: [CCActionMoveBy(duration: 0.01, position: CGPoint(x: 2, y: 2)),
            CCActionMoveBy(duration: 0.01, position: CGPoint(x: 0, y: -2)), CCActionMoveBy(duration: 0.01, position: CGPoint(x: -2, y: 2)), CCActionMoveBy(duration: 0.01, position: CGPoint(x: 0, y: -2))]), times: 2)
        player.stopAllActions()
        player.runAction(shakeAction)
    }
    
    
//    displayer the winner label
    func displayWonLabel(paddleColor: String) {
        playerWonLabel.string = "\(paddleColor) Player Won!"
        playerWonLabel.visible = true
        playerWonLabel.runAction(CCActionBlink(duration: 1))
    }
    
    
//    play again button pressed
    func playAgain() {
        let scene = CCBReader.loadAsScene("MainScene")
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().replaceScene(scene, withTransition: transition)
    }
    
    override func update(delta: CCTime) {
        if deadPlayerCounter == 3 {
            gameEnded = true
            for playerContainer in players {
                for child in playerContainer.children {
                    if let player = child as? Player {
                        if player.playerAlive == true {
                            displayWonLabel(playerContainer.player.paddle.name)
                        }
                    }
                }
            }
            ballTimeManager.invalidate()
            restartButton.visible = true
        }
        
        if gamePhysicsNode.children != nil {
            for child in gamePhysicsNode.children {
                if let ball = child as? Ball {
                    if CGRectContainsPoint(playBox.boundingBox(), ball.position) {
                        if ccpLength(ball.physicsBody.velocity) > maxSpeed {
                            println("TOO FAST")
                            ball.physicsBody.velocity = ccpMult(ball.physicsBody.velocity, 0.8)
                        }
                    } else {
                        ball.removeFromParentAndCleanup(true)
                        let index = find(balls, ball)
                        balls.removeAtIndex(index!)
                        
//        always keep a ball in the play field
                        if balls.count == 0 && gameEnded == false {
                            runAction(CCActionSequence(array: [CCActionDelay(duration: 1), CCActionCallBlock(block: { () -> Void in
                                self.createNewBall()
                            })]))
                        }
                    }
                }
            }
        }
        
    }
    
}
