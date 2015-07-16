//
//  Menu.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
protocol MenuDelegate {
    
    func twoPlayers()
    func threePlayers()
    func fourPlayers()
    func unpauseGame()
}

import Foundation

class Menu: CCNode {
    
    weak var twoPlayers : CCButton!
    weak var threePlayers : CCButton!
    weak var fourPlayers : CCButton!
    weak var startGameButton : CCButton!
    weak var continueButton : CCButton!
    weak var menuContainer : CCNode!
    weak var menuBody : CCSprite!
    var delegate : MenuDelegate?
    
    
    func didLoadFromCCB() {
//        fourPlayers.highlighted = true
        addDropShadow()
    }
    
    func addDropShadow() {
        var shadow = CCEffectDropShadow(shadowOffset: GLKVector2Make(3, -5), shadowColor: CCColor.whiteColor(), blurRadius: 0)
        menuBody.effect = shadow
    }
    
    func startGame() {
        let scene = CCBReader.loadAsScene("MainScene")
        self.animationManager.runAnimationsForSequenceNamed("closeMenu")
        CCDirector.sharedDirector().replaceScene(scene, withTransition: CCTransition(fadeWithDuration: 0.25))
//        runAction(CCActionSequence(array: [CCActionDelay(duration: 0.48) , CCActionCallBlock(block: { () -> Void in
//        })]))
    }
    
    func continueTapped() {
        delegate?.unpauseGame()
    }
    
    func toggleHardMode() {
        GameSettings.hardMode = !GameSettings.hardMode
    }

    func twoPlayersTapped() {
        delegate?.twoPlayers()
        GameSettings.activePlayers = 2
        startGameButton.title = "Start 2 Players Game"
        threePlayers.selected = false
        fourPlayers.selected = false
    }
    
    func threePlayersTapped() {
        delegate?.threePlayers()
        GameSettings.activePlayers = 3
        startGameButton.title = "Start 3 Players Game"
        twoPlayers.selected = false
        fourPlayers.selected = false

    }

    func fourPlayersTapped() {
        delegate?.fourPlayers()
        GameSettings.activePlayers = 4
        startGameButton.title = "Start 4 Players Game"
        twoPlayers.selected = false
        threePlayers.selected = false
    }

}
