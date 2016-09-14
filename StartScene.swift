//
//  StartScene.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class StartScene: CCScene, MenuDelegate {
    
    weak var placeHolder1 : CCNode!
    weak var placeHolder2 : CCNode!
    weak var placeHolder3 : CCNode!
    weak var placeHolder4 : CCNode!
    var placeHolders = [CCNode]()
    var menuNode : Menu!
    var players = [PlayerContainer]()

    func didLoadFromCCB() {
        placeHolders = [placeHolder1, placeHolder2, placeHolder3, placeHolder4]
        setupPlayers()
        menuNode.delegate = self
    }
    
    func setupPlayers() {
//        println("Number Of Players \(GameSettings.numberOfPlayers)")
        for i in 0..<4 {
            var playerContainer = CCBReader.load("PlayerContainer") as! PlayerContainer
            playerContainer.position = placeHolders[i].position
            playerContainer.setupPlayer(i)
            addChild(playerContainer)
            players.append(playerContainer)
        }
    }
    
    
    func twoPlayers() {
        disablePlayer("player3")
        disablePlayer("player4")
    }
    
    func threePlayers() {
        enablePlayer("player4")
        disablePlayer("player3")
    }
    
    func fourPlayers() {
        enablePlayer("player4")
        enablePlayer("player3")
    }
    
    func disablePlayer(name: String) {
        var playerX = getChildByName(name , recursively: false) as! PlayerContainer
        playerX.circle.opacity = 0.5
        playerX.player.paddle.opacity = 0.0
    }
    
    func enablePlayer(name: String) {
        var playerX = getChildByName(name , recursively: false) as! PlayerContainer
        playerX.circle.opacity = 1
        playerX.player.paddle.opacity = 1
    }

    func continueGame() {
        
    }
    
    func unpauseGame() {
        
    }
    
}
