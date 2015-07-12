//
//  SoundManager.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

struct SoundManager {
    
    static var audio = OALSimpleAudio.sharedInstance()
    
    static func playRollingLoop() {
        audio.playEffect("metal on wood rolling loop.wav", loop: true)
    }
}
