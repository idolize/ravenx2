//
//  Enemy.swift
//  RavenX2
//
//  Created by David Idol on 11/18/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import GameplayKit
import SpriteKit

class Enemy: EntityWithSpriteComponent {
    init(position: CGPoint) {
        super.init(textureAtlas: TextureAsset.genericEnemyAtlas, maxHeight: 40)
        
        // TODO move physics to component?
        node.position = CGPoint(x: position.x + node.size.width, y: position.y)
        let physicsBody = SKPhysicsBody(rectangleOf: node.size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = PhysicsType.Enemy
        physicsBody.contactTestBitMask = PhysicsType.Projectile
        physicsBody.collisionBitMask = PhysicsType.None
        physicsBody.allowsRotation = false
        node.physicsBody = physicsBody
        
        // Move the enemy left
        let animationDuration: TimeInterval = 3
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: -node.size.width, y: position.y), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        node.run(SKAction.sequence(actionArray))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
