//
//  Projectile.swift
//  RavenX2
//
//  Created by David Idol on 11/17/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import GameplayKit

class Projectile: EntityWithSpriteComponent {
    
    init(team: Team, position: CGPoint) {
        let texture = SKTexture(imageNamed: "torpedo")
        super.init(texture: texture, size: texture.size())
        let physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        physicsBody.isDynamic = true
        physicsBody.categoryBitMask = PhysicsType.Projectile
        physicsBody.contactTestBitMask = PhysicsType.Enemy
        physicsBody.collisionBitMask = PhysicsType.None
        physicsBody.usesPreciseCollisionDetection = true
        node.physicsBody = physicsBody
        // TODO avoid hardcoding this assumption that shooting to the right direction
        node.position = CGPoint(x: position.x + node.size.width / 2, y: position.y)
        
        addComponent(TeamComponent(team: team))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
