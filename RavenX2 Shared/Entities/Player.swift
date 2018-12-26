//
//  Player.swift
//  RavenX2
//
//  Created by David Idol on 11/16/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import SceneKit
import GameplayKit

private let playerSpeed: CGFloat = 450
private let fingerWidth: CGFloat = 30

class Player: EntityWithSpriteComponent {
    
    let entityManager: EntityManager
    
    init(entityManager: EntityManager, position: CGPoint, constraints: [SKConstraint]?) {
        self.entityManager = entityManager
        super.init(textureAtlas: TextureAsset.heroShipAtlas, maxWidth: 60)
        
        // TODO move physics to component?
        node.position = position
        let physicsBody = SKPhysicsBody(rectangleOf: node.size)
        physicsBody.categoryBitMask = PhysicsType.Player
        physicsBody.collisionBitMask = PhysicsType.None
        physicsBody.allowsRotation = false
        node.physicsBody = physicsBody
        node.constraints = constraints
        node.zPosition = 10
        
        let emitter = SKEmitterNode(fileNamed: "Thruster")!
        emitter.targetNode = entityManager.scene
        emitter.position.x -= (node.size.width / 2) - 5
        node.addChild(emitter)
        
        // TODO conditionally add this vs keyboard component
        #if os(iOS)
        addComponent(TouchComponent(self))
        #endif
        #if os(OSX)
        addComponent(KeyboardComponent())
        #endif
        
        addComponent(FiringComponent(entityManager: self.entityManager, firing: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        #if os(iOS)
        if let touchComponent = component(ofType: TouchComponent.self) {
            let lastTouch = touchComponent.lastTouchLocation
            updatePhysics(destination: lastTouch);
        }
        #endif
        #if os(OSX)
        let keyboardComponent = component(ofType: KeyboardComponent.self)
        let currentPosition = node.position
        if let keyboard = keyboardComponent?.keyboard {
            var destX = currentPosition.x
            if keyboard.pressed(keys: Key.Left, Key.A) {
                destX -= 100
            }
            if keyboard.pressed(keys: Key.Right, Key.D) {
                destX += 100
            }
            var destY = currentPosition.y
            if keyboard.pressed(keys: Key.Up, Key.W) {
                destY += 100
            }
            if keyboard.pressed(keys: Key.Down, Key.S) {
                destY -= 100
            }
            let destination = CGPoint(x: destX, y: destY)
            updatePhysics(destination: destination);
            
            component(ofType: FiringComponent.self)?.isFiring = keyboard.pressed(keys: Key.Space)
        }
        #endif
    }
    
    // Avoids "jittering" from very slight movements while holding down a touch
    private func shouldMove(currentPosition: CGPoint, newPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - newPosition.x) > fingerWidth ||
            abs(currentPosition.y - newPosition.y) > fingerWidth / 3
    }
  
    // Updates the player's position by moving towards the last touch made
    private func updatePhysics(destination: CGPoint?) {
        if let touchPos = destination {
            let newPosition = CGPoint(x: touchPos.x + fingerWidth, y: touchPos.y)
            let currentPosition = node.position
            if shouldMove(currentPosition: currentPosition, newPosition: newPosition) {
                // Avoid moving the player directly under the touch point
                
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

#if os(iOS)
// Handle touch events
extension Player: TouchEventDelegate {
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
        // TODO use state machine for this
        component(ofType: FiringComponent.self)?.isFiring = true
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
        // TODO use state machine for this
        component(ofType: FiringComponent.self)?.isFiring = false
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
        // TODO use state machine for this
        component(ofType: FiringComponent.self)?.isFiring = false
    }
}
#endif
