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
        super.init(
            textureAtlas: TextureAsset.greenBlobAtlas,
            maxHeight: 20,
            animateForever: false,
            timePerFrame: 0.12
        )
        
        let physicsBody = SKPhysicsBody(circleOfRadius: node.size.height / 2)
        physicsBody.isDynamic = true
        physicsBody.categoryBitMask = PhysicsType.Projectile
        physicsBody.contactTestBitMask = PhysicsType.Enemy
        physicsBody.collisionBitMask = PhysicsType.None
        physicsBody.usesPreciseCollisionDetection = true
        node.physicsBody = physicsBody
        node.anchorPoint = CGPoint(x: 0.8, y: 0.5)
        // TODO avoid hardcoding this assumption that shooting to the right direction
        node.position = CGPoint(x: position.x + node.size.width / 2, y: position.y)
        
        addComponent(TeamComponent(team: team))
        animationComponent?.animateOnce(node: node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playSound() {
        node.run(SoundAsset.zap)
    }
    
}
