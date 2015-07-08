//
//  StartScene.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class StartScene: CCScene {

    func didLoadFromCCB() {
        
    }
    
    func startGame() {
        let scene = CCBReader.loadAsScene("MainScene")
        var transition = CCTransition(fadeWithDuration: 0.25)
        CCDirector.sharedDirector().replaceScene(scene, withTransition: transition)
    }
    
}
