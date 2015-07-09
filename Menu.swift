//
//  Menu.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


import Foundation

class Menu: CCNode {
    
    weak var numberOfPlayersLabel : CCLabelTTF!
    weak var validationLabel : CCLabelTTF!
    weak var startGameButton : CCButton!
    
    func startGame() {
        let scene = CCBReader.loadAsScene("MainScene")
        var transition = CCTransition(fadeWithDuration: 0.25)
        CCDirector.sharedDirector().replaceScene(scene, withTransition: transition)
    }

}
