//
//  Player.swift
//  RavenX2
//
//  Created by David Idol on 11/16/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import SceneKit
import GameplayKit

let playerSpeed: CGFloat = 550.0

// TODO rewrite using components
class Player: GKEntity {
    let entityManager: EntityManager
    
    init(position: CGPoint, constraints: [SKConstraint]?, entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        // TODO move animation to component
        let animatedAtlas = SKTextureAtlas(named: "HeroShip")
        var frames: [SKTexture] = []
        for i in 1...animatedAtlas.textureNames.count {
            let textureName = "HeroShip\(i)"
            frames.append(animatedAtlas.textureNamed(textureName))
        }
        let firstFrameTexture = frames[0]
        let size = GeometryHelpers.constrainSizeToWidth(firstFrameTexture.size(), maxWidth: 50)
        let spriteComponent = SpriteComponent(entity: self, texture: firstFrameTexture, size: size)
        addComponent(spriteComponent)
        // TODO move physics to component
        let node = spriteComponent.node
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = PhysicsType.Player
        node.physicsBody?.collisionBitMask = PhysicsType.None
        node.physicsBody?.allowsRotation = false
        node.constraints = constraints
        node.run(SKAction.repeatForever(
            SKAction.animate(with: frames,
                             timePerFrame: 0.05,
                             resize: false,
                             restore: true)),
                 withKey:"thruster")
        // TODO Shooting should only happen when touch is down...
        addComponent(FiringComponent(entityManager: entityManager))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var node: SKSpriteNode {
        return component(ofType: SpriteComponent.self)!.node
    }
    
    // Determines if the player's position should be updated
    private func shouldMove(currentPosition: CGPoint, newPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - newPosition.x) > node.frame.width / 4 ||
            abs(currentPosition.y - newPosition.y) > node.frame.height / 4
    }
  
    // TODO move to component
    // Updates the player's position by moving towards the last touch made
    func updatePhysics(destination: CGPoint?) {
        if let newPosition = destination {
            let currentPosition = node.position
            if shouldMove(currentPosition: currentPosition, newPosition: newPosition) {
                
                let angle = atan2(currentPosition.y - newPosition.y, currentPosition.x - newPosition.x) + .pi
                
                let velocotyX = playerSpeed * cos(angle)
                let velocityY = playerSpeed * sin(angle)
                
                let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
                node.physicsBody!.velocity = newVelocity;
                return
            }
        }
        node.physicsBody!.isResting = true
    }
    
}
