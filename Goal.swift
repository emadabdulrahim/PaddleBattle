//
//  Goal.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Goal: CCNode {
    
    func didLoadFromCCB() {
        self.physicsBody.sensor = true
//        self.physicsBody.allowsRotation = false
    }
}