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
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }
    
    private func getRandomYPos() -> CGFloat {
        let scene = entityManager.scene
        return CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75)
    }
    
    // TODO use this instead? https://gist.github.com/Ben-G/cb1708b1068d2bc5916f
    @discardableResult
    func spawnEnemy1(positionY: CGFloat? = nil) -> Enemy1 {
        // Spawns a new enemy off screen at the right
        let scene = entityManager.scene
        let position = CGPoint(x: scene.size.width, y: positionY ?? getRandomYPos())
        let enemy = Enemy1(position: position)
        entityManager.add(enemy)
        return enemy
    }
    
    @discardableResult
    func spawnEnemy2(positionY: CGFloat? = nil) -> Enemy2 {
        // Spawns a new enemy off screen at the right
        let scene = entityManager.scene
        let position = CGPoint(x: scene.size.width, y: positionY ?? getRandomYPos())
        let enemy = Enemy2(position: position)
        entityManager.add(enemy)
        return enemy
    }
    
    func collisionDetected(enemy: Enemy1, projectile: Projectile) {
        let explosion = Explosion(entityManager: entityManager, position: enemy.node.position)
        entityManager.add(explosion)
        entityManager.remove(projectile)
        entityManager.remove(enemy)
    }
}
