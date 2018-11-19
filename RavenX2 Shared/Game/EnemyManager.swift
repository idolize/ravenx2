//
//  EnemyManager.swift
//  RavenX2
//
//  Created by David Idol on 11/18/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import CoreGraphics
import SpriteKit

class EnemyManager {
    let entityManager: EntityManager!
    var timeOfLastSpawn: TimeInterval = 0
    var spawnFrequency: TimeInterval?
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }
    
    func spawnEnemy(currentTime: TimeInterval) {
        // Spawns a new enemy off screen at the right
        let scene = entityManager.scene
        let positionY = CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75)
        let position = CGPoint(x: scene.size.width, y: positionY)
        let enemy = Enemy(position: position)
        entityManager.add(enemy)
        timeOfLastSpawn = currentTime
    }
    
    func startSpawningEnemiesRegularly(frequency: TimeInterval) {
        assert(frequency > 0, "Frequency must be a number greater than 0")
        spawnFrequency = frequency
    }
    
    func stopSpawningEnemiesRegularly() {
        spawnFrequency = nil
    }
    
    func collisionDetected(enemy: Enemy, projectile: Projectile) {
        let explosion = Explosion(entityManager: entityManager, position: enemy.node.position)
        entityManager.add(explosion)
        entityManager.remove(projectile)
        entityManager.remove(enemy)
    }
    
    func update(_ currentTime: TimeInterval) {
        if let frequency = spawnFrequency {
            let timeSinceLastSpawn = currentTime - timeOfLastSpawn;
            if (timeSinceLastSpawn > frequency) {
                spawnEnemy(currentTime: currentTime)
            }
        }
    }
}
