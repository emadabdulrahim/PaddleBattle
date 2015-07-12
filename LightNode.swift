//
//  LightNode.swift
//  PaddleBattle
//
//  Created by Emad Mohamad on 7/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class LightNode : CCLightNode {
    
    override init!(type: CCLightType, groups: [AnyObject]!, color: CCColor!, intensity: Float) {
        super.init(type: type, groups: groups, color: color, intensity: intensity)
    }
}
