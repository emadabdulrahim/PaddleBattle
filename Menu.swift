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
}

import Foundation

class Menu: CCNode {
    
    weak var twoPlayers : CCButton!
    weak var threePlayers : CCButton!
    weak var fourPlayers : CCButton!
    weak var startGameButton : CCButton!
    var delegate : MenuDelegate?
    
    
    func didLoadFromCCB() {
//        fourPlayers.highlighted = true
    }
    
    func startGame() {
        let scene = CCBReader.loadAsScene("MainScene")
        var transition = CCTransition(fadeWithDuration: 0.25)
        CCDirector.sharedDirector().replaceScene(scene, withTransition: transition)
    }

    func twoPlayersTapped() {
        delegate?.twoPlayers()
        GameSettings.numberOfPlayers = 2
        twoPlayers.highlighted = true
        startGameButton.title = "Start 2 Players Game"
        threePlayers.highlighted = false
        fourPlayers.highlighted = false
    }
    
    func threePlayersTapped() {
        delegate?.threePlayers()
        GameSettings.numberOfPlayers = 3
        threePlayers.highlighted = true
        startGameButton.title = "Start 3 Players Game"
        twoPlayers.highlighted = false
        fourPlayers.highlighted = false
    }

    func fourPlayersTapped() {
        delegate?.fourPlayers()
        GameSettings.numberOfPlayers = 4
        startGameButton.title = "Start 4 Players Game"
        twoPlayers.highlighted = false
        threePlayers.highlighted = false
    }

}
