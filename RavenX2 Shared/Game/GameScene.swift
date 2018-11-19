//
//  GameScene.swift
//  RavenX2 Shared
//
//  Created by David Idol on 11/15/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
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
    
    var gameTimer: Timer!
    
    class func newGameScene(_ view: SKView) -> GameScene {
        let scene = GameScene(size: view.bounds.size)
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .resizeFill
        // For Debug Use only
        view.showsPhysics = true
        return scene
    }
    
    func setUpScene(_ view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        // Score
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = SKColor.white
        score = 0
        self.addChild(scoreLabel)
        
        // Background
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: self.size.width / 2, y: self.size.height)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
      
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
        enemyManager.startSpawningEnemiesRegularly(frequency: 0.75)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // TODO write this in a way that doesn't depend on the order of the numbers...
        if (firstBody.categoryBitMask & PhysicsType.Enemy) != 0 && (secondBody.categoryBitMask & PhysicsType.Projectile) != 0 {
            enemyHit(enemyNode: firstBody.node as! SKSpriteNode, projNode: secondBody.node as! SKSpriteNode)
        }
    }
    
    func enemyHit(enemyNode: SKSpriteNode, projNode: SKSpriteNode) {
        guard let proj = projNode.entity, let enemy = enemyNode.entity else {
            fatalError("Unexpected types for enemyHit")
        }
        
        enemyManager.collisionDetected(enemy: enemy as! Enemy, projectile: proj as! Projectile)
        score += 5
    }
    
    
    override func didMove(to view: SKView) {
        self.setUpScene(view)
    }

    override func update(_ deltaTime: TimeInterval) {
        entityManager.update(deltaTime)
        enemyManager.update(deltaTime)
    }
    
    override func didFinishUpdate() {
        #if os(OSX)
        Keyboard.sharedKeyboard.update()
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
        entityManager.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        entityManager.touchesBegan(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        entityManager.touchesBegan(touches, with: event)
    }
}
#endif


#if os(OSX)
// Handle keyboard events
extension GameScene {
    override func keyUp(theEvent: NSEvent) {
        entityManager.handleKey(theEvent, isDown: false)
    }

    override func keyDown(theEvent: NSEvent) {
        entityManager.handleKey(theEvent, isDown: true)
    }
}
#endif
