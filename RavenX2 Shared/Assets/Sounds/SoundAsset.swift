//
//  Sounds.swift
//  RavenX2
//
//  Created by David Idol on 11/18/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import SpriteKit

struct SoundAsset {
    static let explosion = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
    static let torpedo = SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false)
    static let zap = SKAction.playSoundFileNamed("sfx_zap.mp3", waitForCompletion: false)
}
