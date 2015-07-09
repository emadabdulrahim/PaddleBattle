//
//  StartScene.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class StartScene: CCScene {
    
    weak var bluePlayer : PlayerContainer!
    weak var pinkPlayer : PlayerContainer!
    weak var greenPlayer : PlayerContainer!
    weak var redPlayer : PlayerContainer!
    var menuNode : Menu!


    func didLoadFromCCB() {
    }
    
    override func onEnterTransitionDidFinish() {
        menuNode.animationManager.runAnimationsForSequenceNamed("showMenu")
    }
    
}
