//
//  Level1.swift
//  RavenX2
//
//  Created by David Idol on 11/26/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class Level1 {
    let enemyManager: EnemyManager
    let sceneState: GKStateMachine
    private let enemyWaveCreator: EnemyWaveCreator
    
    lazy var action: SKAction = {
        return SKAction.sequence([
            SKAction.wait(forDuration: 3),
            enemyWaveCreator.createWaveAction(numEnemies: 2),
            SKAction.wait(forDuration: 1),
            enemyWaveCreator.createWaveAction(numEnemies: 4),
            SKAction.wait(forDuration: 1),
            enemyWaveCreator.createWaveAction(numEnemies: 6),
            SKAction.wait(forDuration: 3),
            SKAction.run {
                #if os(iOS)
                let utterance = AVSpeechUtterance(string: "Level 1 completed")
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
                #endif
                #if os(OSX)
                let synthesizer = NSSpeechSynthesizer()
                synthesizer.startSpeaking("Level 1 completed")
                #endif
                
                self.sceneState.enter(MenuSceneState.self)
            }
        ])
    }()
    
    init(enemyManager: EnemyManager, sceneState: GKStateMachine) {
        self.enemyManager = enemyManager
        self.sceneState = sceneState
        self.enemyWaveCreator = EnemyWaveCreator(enemyManager: enemyManager)
    }
}
