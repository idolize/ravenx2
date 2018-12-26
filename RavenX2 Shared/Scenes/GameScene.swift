//
//  GameScene.swift
//  RavenX2 Shared
//
//  Created by David Idol on 11/15/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: BaseScene, SKPhysicsContactDelegate {
    
    var player: Player!
    // Entity-component system
    var entityManager: EntityManager!
    var enemyManager: EnemyManager!
    
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private let textToSpeech: TextToSpeech = TextToSpeech()
    
    func setUpScene(_ view: SKView) {
        backgroundColor = SKColor.init(red: 0.2, green: 0, blue: 0.05, alpha: 1)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // Score
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLabel.fontName = "KohinoorBangla-Semibold"
        scoreLabel.fontSize = 38
        scoreLabel.fontColor = SKColor.red
        scoreLabel.alpha = 0.3
        score = 0
        addChild(scoreLabel)
        
        // Background
        // TODO make a class for this
        let starfield = SKEmitterNode(fileNamed: "Starfield")!
        starfield.position = CGPoint(x: self.size.width, y: self.size.height / 2)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -2
        let starfield2 = SKEmitterNode(fileNamed: "Starfield")!
        starfield2.particleBirthRate = starfield.particleBirthRate / 3
        starfield2.particleColorSequence = nil
        starfield2.particleColor = SKColor.orange
        starfield2.particleAlpha = CGFloat.maximum(starfield.particleAlpha * 2, 0.7)
        starfield2.position = starfield.position
        starfield2.particleSpeed = starfield.particleSpeed * 2
        starfield2.particleScale = starfield.particleScale * 2
        starfield2.advanceSimulationTime(9)
        addChild(starfield2)
        starfield2.zPosition = starfield.zPosition + 1
      
        // Create entity manager
        entityManager = EntityManager(scene: self)
        enemyManager = EnemyManager(entityManager: entityManager)
        
        // Player
        let xConstraint = SKConstraint.positionX(SKRange(lowerLimit: 0, upperLimit: self.frame.size.width))
        let yConstraint = SKConstraint.positionY(SKRange(lowerLimit: 0, upperLimit: self.frame.size.height))
        let constraints = [ xConstraint, yConstraint ]
        player = Player(
            entityManager: entityManager,
            position: CGPoint(x: 40, y: self.frame.size.height / 2),
            constraints: constraints
        )
        entityManager.add(player)
        self.run(Level1(enemyManager: enemyManager, sceneState: sceneState).action)
    }
    
    private func checkCollision(
        bodyA: SKPhysicsBody,
        typeA: UInt32,
        bodyB: SKPhysicsBody,
        typeB: UInt32 = PhysicsType.All
    ) -> Bool {
        var firstType = typeB
        var secondType = typeA
        if typeA < typeB {
            firstType = typeA
            secondType = typeB
        }
        return (bodyA.categoryBitMask & firstType) != 0 &&
            (bodyB.categoryBitMask & secondType) != 0
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody = contact.bodyB
        var secondBody: SKPhysicsBody = contact.bodyA
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        let firstNode = firstBody.node as! SKSpriteNode
        let secondNode = secondBody.node as! SKSpriteNode
        
        if checkCollision(bodyA: firstBody, typeA: PhysicsType.Enemy,
                          bodyB: secondBody, typeB: PhysicsType.Projectile) {
            enemyHit(enemyNode: firstNode, projNode: secondNode)
        }
        if checkCollision(bodyA: firstBody, typeA: PhysicsType.Player,
                          bodyB: secondBody, typeB: PhysicsType.Enemy) {
            playerHit(playerNode: firstNode, enemyNode: secondNode)
        }
    }
    
    func enemyHit(enemyNode: SKSpriteNode, projNode: SKSpriteNode) {
        guard let proj = projNode.entity, let enemy = enemyNode.entity else {
            fatalError("Unexpected types for enemyHit")
        }
        
        enemyManager.collisionDetected(enemy: enemy as! Enemy1, projectile: proj as! Projectile)
        score += 5
    }
    
    func playerHit(playerNode: SKSpriteNode, enemyNode: SKSpriteNode) {
        player!.killed()
        self.run(SKAction.sequence([
            SKAction.run {
                self.textToSpeech.say("Game Over")
            },
            SKAction.wait(forDuration: 3),
            SKAction.run {
                self.sceneState.enter(MenuSceneState.self)
            }]))
    }
    
    
    override func didMove(to view: SKView) {
        self.setUpScene(view)
    }

    override func update(_ deltaTime: TimeInterval) {
        entityManager.update(deltaTime)
    }
    
    override func didFinishUpdate() {
        #if os(OSX)
        Keyboard.globalKeyboard.update()
        #endif
    }
}

#if os(iOS)
// Handle touch events
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       entityManager.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        entityManager.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        entityManager.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        entityManager.touchesCancelled(touches, with: event)
    }
}
#endif


#if os(OSX)
// Handle keyboard events
extension GameScene {
    override func keyUp(with theEvent: NSEvent) {
        entityManager.handleKey(theEvent: theEvent, isDown: false)
    }

    override func keyDown(with theEvent: NSEvent) {
        entityManager.handleKey(theEvent: theEvent, isDown: true)
    }
}
#endif
