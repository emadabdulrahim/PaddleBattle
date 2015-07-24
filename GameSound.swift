//
//  GameSound.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

/** GameSound Class

*/
class GameSound {

    static let sharedInstance = GameSound()

    private init() {
    }
    
    func setupAudio() {
        OALSimpleAudio.sharedInstance().preloadEffect(GameSettings.spawnSound)
        OALSimpleAudio.sharedInstance().preloadEffect(GameSettings.paddleHitSound)
        OALSimpleAudio.sharedInstance().preloadEffect(GameSettings.hitSound)
    }
    
    
    
    func playSound(sound: String, volume volumeLevel : Float) {
        OALSimpleAudio.sharedInstance().playEffect(sound, volume: volumeLevel, pitch: 1.0, pan: 0, loop: false)
    }
}
