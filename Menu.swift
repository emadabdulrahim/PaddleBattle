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
    
    weak var twoPlayers : CCSprite!
    weak var threePlayers : CCSprite!
    weak var fourPlayers : CCSprite!
    weak var startGameButton : CCSprite!
    weak var continueButton : CCButton!
    weak var toggleHardMode : CCSprite!
    weak var toggleCasualMode : CCSprite!
    weak var menuContainer : CCNode!
    weak var menuBody : CCSprite!
    weak var noOfPlayersLabel : CCLabelTTF!
    
    var arrayOfButtons = [CCSprite]()
    var delegate : MenuDelegate?
    
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        menuBody.opacity = 0.1
        addDropShadow()
        if gameStatus == .Starting {
            twoPlayers.opacity = 0.5
            threePlayers.opacity = 0.5
            continueButton.visible = false
        }
        
        arrayOfButtons = [twoPlayers, threePlayers, fourPlayers]
    }
    
    func addDropShadow() {
        var shadow = CCEffectDropShadow(shadowOffset: GLKVector2Make(3, -5), shadowColor: CCColor.whiteColor(), blurRadius: 0)
        menuBody.effect = shadow
    }
    
    func startGame() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(scene, withTransition: CCTransition(fadeWithDuration: 0.25))
    }
    
    func continueTapped() {
        delegate?.unpauseGame()
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let touchLocation = touch.locationInNode(self)
        if CGRectContainsPoint(twoPlayers.boundingBox(), touchLocation) {
            delegate?.twoPlayers()
            setupGameSettings(twoPlayers)
        } else if CGRectContainsPoint(threePlayers.boundingBox(), touchLocation) {
            delegate?.threePlayers()
            setupGameSettings(threePlayers)
        } else if CGRectContainsPoint(fourPlayers.boundingBox(), touchLocation) {
            delegate?.fourPlayers()
            setupGameSettings(fourPlayers)
        } else if CGRectContainsPoint(startGameButton.boundingBox(), touchLocation) {
            self.animationManager.runAnimationsForSequenceNamed("closeMenu")
        } else if CGRectContainsPoint(toggleHardMode.boundingBox(), touchLocation) {
            GameSettings.hardMode = true
            toggleHardMode.opacity = 1.0
            toggleCasualMode.opacity = 0.5
        } else if CGRectContainsPoint(toggleCasualMode.boundingBox(), touchLocation) {
            GameSettings.hardMode = false
            toggleCasualMode.opacity = 1.0
            toggleHardMode.opacity = 0.5
        }
    }
    
    func setupGameSettings(playersButton: CCSprite) {
        let index = find(arrayOfButtons, playersButton)
        playersButton.opacity = 1.0
        GameSettings.activePlayers = index! + 2
        noOfPlayersLabel.string = "Start \(index! + 2) players game"
        for i in 0..<arrayOfButtons.count {
            if index == i {
                continue
            } else {
                arrayOfButtons[i].opacity = 0.5
            }
        }
    }
}
