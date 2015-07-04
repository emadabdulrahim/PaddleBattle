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
//    var ball : Ball?
    var balls = [Ball]()
    weak var edgeLoop : CCPhysicsNode!
    var gameTimer : NSTimer?
    var insanityTimer : NSTimer?
    var timeToStart : Int = 5
    var countdownLabel : CCLabelTTF!
    var restartButton : CCButton!
    var velocityX : CGFloat = 0
    var velocityY : CGFloat = 0
    let ballLocation : CGFloat = 50
    var ballCorner : BallCorner = .BottomLeft
    
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        multipleTouchEnabled = true
//        edgeLoop.debugDraw = true
        edgeLoop.collisionDelegate = self
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
        
        schedule("setupCountDownLabel", interval: 1)
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "createNewBall", userInfo: nil, repeats: true)
        insanityTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "increaseDiffculty", userInfo: nil, repeats: true)
//        ball = CCBReader.load("Ball") as? Ball
//        ball?.position = ccp(50, 50)
//        edgeLoop.addChild(ball)
//        
//        ball?.physicsBody.applyImpulse(CGPoint(x: 5, y: 5))
        
    }
    
    func increaseDiffculty() {
        velocityX *= 1.2
        velocityY *= 1.2
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "createNewBall", userInfo: nil, repeats: true)
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
        velocityX = CGFloat(arc4random_uniform(6) + 11)
        velocityY = CGFloat(arc4random_uniform(6) + 12)
        ball.position = spawnBallAtLocation(randomCorner)
        println(ball.position)
        edgeLoop.addChild(ball)
        switch ballCorner {
        case .BottomLeft:
            ball.physicsBody.applyImpulse(CGPoint(x: velocityX, y: velocityY))
        case .BottomRight:
            ball.physicsBody.applyImpulse(CGPoint(x: -velocityX, y: velocityY))
        case .TopLeft:
            ball.physicsBody.applyImpulse(CGPoint(x: velocityX, y: -velocityY))
        case .TopRight:
            ball.physicsBody.applyImpulse(CGPoint(x: -velocityX, y: -velocityY))
        }
        ball.physicsBody.allowsRotation = false
        balls.append(ball)
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
    
//    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, typeA ball: CCNode!, typeB goal: CCNode!) -> Bool {
//        println("COLLISION HAPPENED")
//        return true
//    }
    
//    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, goal: Goal!, ball: Ball!) {
//        println("COLLISION HAPPENED")
//    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, goal nodeA: CCNode!, ball nodeB: Ball!) -> ObjCBool {
//        println("Collision Happened")
        
        if let playerContainer = nodeA.parent.parent as? PlayerContainer {
            playerContainer.score--
            if let player = nodeA.parent as? Player {
                player.stopAllActions()
//                player.runAction(CCActionBlink(duration: 0.42, blinks: 4))
            }
        }
        
        return true
    }
    
    func playAgain() {
        let scene = CCBReader.loadAsScene("MainScene")
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().replaceScene(scene, withTransition: transition)
    }
    
    override func update(delta: CCTime) {
        if gameEnded == true {
            gameTimer?.invalidate()
            insanityTimer?.invalidate()
            restartButton.visible = true
        }
        
    }
    
//    func startGame() {
//        ball = Ball()
//        ball?.position = ccp(200, 200)
//        addChild(ball)
////        ball?.physicsBody.applyImpulse(CGPoint(x: 4, y: 4))
//    }
    
}
