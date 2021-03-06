import Foundation
import UIKit


var gameStatus : GameStatus = .Starting



class MainScene: CCNode, CCPhysicsCollisionDelegate, MenuDelegate {
    
    enum BallCorner {
        case BottomLeft
        case BottomRight
        case TopLeft
        case TopRight
    }
    
    weak var placeHolder1 : CCNode!
    weak var placeHolder2 : CCNode!
    weak var placeHolder3 : CCNode!
    weak var placeHolder4 : CCNode!
    weak var centerNode : CCNode!
    weak var playBox : CCNode!
    weak var playerWonLabel : CCLabelTTF!
    weak var gamePhysicsNode : CCPhysicsNode!
    weak var menuLayer : Menu!
    weak var lightNode : CCLightNode!
    weak var backgroundNode : CCSprite!
    
    var placeHolders = [CCNode]()
    var players = [PlayerContainer]()
    var balls = [Ball]()
    var timeToStart : Int = 4
    var countdownLabel : CCLabelTTF!
    var restartButton : CCButton!
    var speed : CGFloat = 1.6
    var ballTimeManager : CCTimer!
    var labelTimeManager : CCTimer!
    var difficultyTimer : CCTimer!
    var elapsedGameTime : CCTime = 0
    var intervalTime = CCTime(15)
    let animations = [
        true : [
            "pink"  : "paddleHardHit",
            "green" : "paddleHardHitTop",
            "red"   : "paddleHardHitRight",
            "blue"  : "paddleHardHitLeft"
        ],
        false : [
            "pink"  : "paddleSoftHit",
            "green" : "paddleSoftHitTop",
            "red"   : "paddleSoftHitRight",
            "blue"  : "paddleSoftHitLeft"
        ]
    ]
    
    
    
    func didLoadFromCCB() {
        //        CCDirector.sharedDirector().displayStats = true
        //        gamePhysicsNode.debugDraw = true
        userInteractionEnabled = true
        multipleTouchEnabled = true
        gamePhysicsNode.zOrder = 100
        gamePhysicsNode.collisionDelegate = self
        gameStatus = .Running
        deadPlayerCounter = 0
        placeHolders = [placeHolder1, placeHolder2, placeHolder3, placeHolder4]
        menuLayer.delegate = self
        if GameSettings.hardMode == false {
            lightNode = nil
        }
        setupPlayers()
        eliminateInActivePlayers()
    }
    
    func setupPlayers() {
        DebugLog("Number Of Players \(GameSettings.numberOfPlayers)")
        for i in 0..<4 {
            var playerContainer = CCBReader.load("PlayerContainer") as! PlayerContainer
            playerContainer.position = placeHolders[i].position
//            playerContainer.name = "player\(i)"
            playerContainer.setupPlayer(i)
            gamePhysicsNode.addChild(playerContainer)
            addChild(playerContainer.scoreManager)
            playerContainer.scoreManager.position = centerNode.position
            DebugLog("\(playerContainer.scoreManager.position)")
            players.append(playerContainer)
        }
    }
    
    func eliminateInActivePlayers() {
        if GameSettings.activePlayers == GameSettings.numberOfPlayers {
            return
        } else {
            let nonActivePlayers = GameSettings.numberOfPlayers - GameSettings.activePlayers
            for i in 3...(nonActivePlayers+2) {
                for (var j = 4;  j >= 0; j-- ) {
                    players[i-1].score--
                    
                }
            }
        }
    }
    
    func setupCountDownLabel() {
        timeToStart--
        var labelText : String
        labelText = "\(timeToStart)"
        if timeToStart == 0 {
            labelText = "GO!"
        }
        countdownLabel.string = labelText
        countdownLabel.zOrder = 125
        var labelAction = CCActionSequence(array: [CCActionEaseInOut(action: CCActionScaleBy(duration:0.4, scale: 1.5), rate: 5), CCActionFadeOut(duration: 0.25)])
        countdownLabel.runAction(labelAction)
        
        if timeToStart < 0 {
            self.removeChild(countdownLabel, cleanup: true)
        }
    }
    
    override func onEnterTransitionDidFinish() {
        labelTimeManager = schedule("setupCountDownLabel", interval: 1, repeat: UInt(timeToStart), delay: 0.3)
        ballTimeManager = schedule("createNewBall", interval: intervalTime, repeat: 99999, delay: 4)
        difficultyTimer = schedule("increaseDiffculty", interval: intervalTime*2, repeat: 99999, delay: intervalTime*2)
    }
    
    func increaseDiffculty() {
        speed *= 1.5
        intervalTime *= 0.6
        ballTimeManager.invalidate()
        ballTimeManager = schedule("createNewBall", interval: intervalTime, repeat: 99999, delay: 5)
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
        ball.gameScene = self
        ball.spawnBallAtLocation(randomCorner)
        //        ball.position = spawnBallAtLocation(randomCorner)
        ball.name = "ball"
        //        println(ball.position)
        runAction(CCActionSequence(array: [CCActionCallBlock(block: { () -> Void in
            self.setupSpawnParticle(ball.position)
        }), CCActionDelay(duration: 0.5), CCActionCallBlock(block: { () -> Void in
            ball.addBallAndApplyImpulse(self.speed)
            if self.lightNode == nil {
                ball.addTrail()
            } else if self.lightNode?.depth > 55 {
                ball.addTrail()
            }
        })]))
        
    }
    
    
    
    func pauseGame() {
        paused = true
        gameStatus = .Paused
        showPopupLayer()
    }
    
    func showPopupLayer() {
        if menuLayer.visible == true {
            return
        }
        menuLayer.continueButton.visible = true
        if gameStatus == .Ended {
            menuLayer.continueButton.visible = false
        }
        menuLayer.visible = true
        menuLayer.animationManager.runAnimationsForSequenceNamed("openMenu")
        menuLayer.zOrder = 200
    }
    
    func unpauseGame() {
        menuLayer.animationManager.runAnimationsForSequenceNamed("closeMenuInGame")
    }
    
    func continueGame() {
        paused = false
        gameStatus = .Running
        menuLayer.visible = false
    }
    
    //    Ball colliding with Goal Node, decrease player score
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, goal nodeA: CCNode!, ball nodeB: Ball!) -> ObjCBool {
//        println("Collision Happened")
        let goalNode = nodeA
        if gameStatus == .Ended {
            return false
        }
        if let playerContainer = nodeA.parent as? PlayerContainer {
            playerContainer.score--
        }
        
        if goalNode.physicsBody.sensor == false {
            GameSound.sharedInstance.playSound(GameSettings.hitSound, volume: 1.0)
        }
        return true
    }
    
    //    shake paddle when ball hits it hard
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, ball nodeA: Ball!, paddle nodeB: CCSprite!) {
        let ball = nodeB
        let paddleBody = nodeB as CCSprite
        var energy : CGFloat = pair.totalKineticEnergy
//        println("PADDLE energy \(energy)")
        let player = nodeB.parent
        gamePhysicsNode.space.addPostStepBlock({ () -> Void in
            paddleBody.animationManager.runAnimationsForSequenceNamed(self.animations[pair.totalKineticEnergy > 400]![player.name])
            }, key: paddleBody)
        GameSound.sharedInstance.playSound(GameSettings.paddleHitSound, volume: 1.0)
      
    }
    
    //    add spark particle when ball bounce on edges
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, edge nodeA: CCPhysicsNode!, ball nodeB: Ball!) {
        //        let energy = pair.totalKineticEnergy
        //        println("energy \(CGFloat(energy))")
        let spark = CCBReader.load("Spark") as! CCParticleSystem
        spark.position = nodeB.position
        spark.particlePositionType = CCParticleSystemPositionType.Free
        addChild(spark)
        GameSound.sharedInstance.playSound(GameSettings.hitSound, volume: 1.0)
    }
    
    
    //    displayer the winner label
    func displayWonLabel(paddleColor: String) {
        playerWonLabel.string = "\(paddleColor) player won!"
        playerWonLabel.zOrder = 350
        playerWonLabel.visible = true
        playerWonLabel.animationManager.runAnimationsForSequenceNamed("wonLabel")
        playerWonLabel.runAction(CCActionSequence(array: [CCActionDelay(duration: 0.5), CCActionCallBlock(block: { () -> Void in
            self.loadFireworks()
        })]))
    }
    
    func loadFireworks() {
        var fireworks = CCBReader.load("Fireworks") as! CCParticleSystem
        fireworks.position = CGPoint(x: playerWonLabel.position.x + 100, y: playerWonLabel.position.y)
        playerWonLabel.addChild(fireworks)
        fireworks.zOrder = -1
    }
    
    
    //    play again button pressed
    func playAgain() {
        let scene = CCBReader.loadAsScene("MainScene")
        var transition = CCTransition(fadeWithDuration: 0.4)
        CCDirector.sharedDirector().replaceScene(scene, withTransition: transition)
    }
    
    override func update(delta: CCTime) {
        elapsedGameTime += delta
        //        find the winner play and call displayWonLabel method with player color
        if deadPlayerCounter == 3 {
            if gameStatus != .Ended {
                for playerContainer in players {
                    if playerContainer.didLose == false {
                        gameStatus = .Ended
                        displayWonLabel(playerContainer.circle.name)
                    }
                }
                difficultyTimer.invalidate()
                ballTimeManager.invalidate()
            }
        }
        
        if elapsedGameTime > 10 {
            if lightNode?.depth > 40{
                lightNode?.depth = lightNode!.depth - Float(10*delta)
            }
        }
    }
    
    
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if gameStatus == .Ended {
            for child in children {
                if let wonLabel = child as? CCLabelTTF {
                    wonLabel.removeFromParentAndCleanup(true)
                    showPopupLayer()
                }
            }
        }
    }
    
    
    
    
    
    
    
    func twoPlayers() {
        
    }
    
    func threePlayers() {
        
    }
    
    func fourPlayers() {
        
    }
    
}
