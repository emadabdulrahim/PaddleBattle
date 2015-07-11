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

    func didLoadFromCCB() {
        placeHolders = [placeHolder1, placeHolder2, placeHolder3, placeHolder4]
        setupPlayers()
        menuNode.delegate = self
    }
    
    func setupPlayers() {
        println("Number Of Players \(GameSettings.numberOfPlayers)")
        for i in 0..<4 {
            var playerContainer = CCBReader.load("PlayerContainer") as! PlayerContainer
            playerContainer.position = placeHolders[i].position
            playerContainer.name = "player\(i+1)"
            playerContainer.setupPlayer()
            addChild(playerContainer)
        }
    }
    
    
    func twoPlayers() {
        
    }
    
    func threePlayers() {
        
    }
    
    func fourPlayers() {
        
    }
    
    override func onEnterTransitionDidFinish() {
        menuNode.animationManager.runAnimationsForSequenceNamed("showMenu")
    }
    
}
