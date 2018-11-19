//
//  Player.swift
//  RavenX2
//
//  Created by David Idol on 11/16/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import SceneKit
import GameplayKit

private let playerSpeed: CGFloat = 550.0

class Player: EntityWithSpriteComponent {
    let entityManager: EntityManager
    
    init(entityManager: EntityManager, position: CGPoint, constraints: [SKConstraint]?) {
        self.entityManager = entityManager
        // TODO move animation to component
        let animatedAtlas = SKTextureAtlas(named: "HeroShip")
        var frames: [SKTexture] = []
        for i in 1...animatedAtlas.textureNames.count {
            let textureName = "HeroShip\(i)"
            frames.append(animatedAtlas.textureNamed(textureName))
        }
        let firstFrameTexture = frames[0]
        let size = GeometryHelpers.constrainSizeToWidth(firstFrameTexture.size(), maxWidth: 50)
        super.init(texture: firstFrameTexture, size: size)
        
        // TODO move physics to component
        node.position = position
        let physicsBody = SKPhysicsBody(rectangleOf: node.size)
        physicsBody.categoryBitMask = PhysicsType.Player
        physicsBody.collisionBitMask = PhysicsType.None
        physicsBody.allowsRotation = false
        node.physicsBody = physicsBody
        node.constraints = constraints
        node.run(SKAction.repeatForever(
            SKAction.animate(with: frames,
                             timePerFrame: 0.05,
                             resize: false,
                             restore: true)),
                 withKey:"thruster")

        // TODO Shooting should only happen when touch is down...
        addComponent(FiringComponent(entityManager: entityManager))
        
        // TODO conditionally add this vs keyboard component
        addComponent(TouchComponent())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        // TODO handle keyboard navigation as well
        let lastTouch = component(ofType: TouchComponent.self)?.lastTouchLocation
        updatePhysics(destination: lastTouch);
    }
    
    // Determines if the player's position should be updated
    private func shouldMove(currentPosition: CGPoint, newPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - newPosition.x) > node.frame.width / 4 ||
            abs(currentPosition.y - newPosition.y) > node.frame.height / 4
    }
  
    // Updates the player's position by moving towards the last touch made
    private func updatePhysics(destination: CGPoint?) {
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
