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
    var lastTouch: UITouch?
    // Entity-component system
    var entityManager: EntityManager!
    
    var scoreLabel: SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameTimer: Timer!
    
    var possibleAliens = ["alien", "alien2", "alien3"]
    
    var xAcceleration: CGFloat = 0
    
    class func newGameScene(_ view: SKView) -> GameScene {
        let scene = GameScene(size: view.bounds.size)
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .resizeFill
        // For Debug Use only
        view.showsPhysics = true
        return scene
    }
    
    func setUpScene(_ view: SKView) {
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: self.size.width / 2, y: self.size.height)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        starfield.zPosition = -1
      
        // Create entity manager
        entityManager = EntityManager(scene: self)
        
        let xConstraint = SKConstraint.positionX(SKRange(lowerLimit: 0, upperLimit: self.frame.size.width))
        let yConstraint = SKConstraint.positionY(SKRange(lowerLimit: 0, upperLimit: self.frame.size.height))
        let constraints = [ xConstraint, yConstraint ]
        player = Player(
            position: CGPoint(x: 40, y: self.frame.size.height / 2),
            constraints: constraints,
            entityManager: entityManager
        )
        entityManager.add(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = SKColor.white
        score = 0
        
        self.addChild(scoreLabel)
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
    }
    
    @objc
    func addAlien () {
        // TODO move this to a entity and entity manager
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.frame.size.height))
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: self.frame.size.width + alien.size.width, y: position)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = PhysicsType.Enemy
        alien.physicsBody?.contactTestBitMask = PhysicsType.Projectile
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
        let animationDuration:TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        
        actionArray.append(SKAction.move(to: CGPoint(x: -alien.size.width, y: position), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
        
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
            torpedoDidCollideWithAlien(alienNode: firstBody.node as! SKSpriteNode, torpedoNode: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    
    func torpedoDidCollideWithAlien(alienNode: SKSpriteNode, torpedoNode: SKSpriteNode) {
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        if let torpedoEntity = torpedoNode.entity {
            entityManager.remove(torpedoEntity)
        }
        // TODO alien not controlled by entity manager yet...
        alienNode.removeAllActions()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        score += 5
    }
    
    
    override func didMove(to view: SKView) {
        self.setUpScene(view)
    }
    
    override func didSimulatePhysics() {
        let touchPosition = lastTouch?.location(in: self)
        player.updatePhysics(destination: touchPosition)
    }
    
    override func update(_ deltaTime: TimeInterval) {
        // Called before each frame is rendered
        entityManager.update(deltaTime)
    }
}

#if os(iOS)
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouch = touches.first
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch: UITouch = touches.first {
            let location = touch.location(in: self)
            let prevLocation = touch.previousLocation(in: self)

            let delta = ((location - prevLocation).normalized()).vector()

            // TODO Show particles to indicate movement
        }
        lastTouch = touches.first
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouch = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouch = nil
    }


}
#endif



#if os(OSX)
extension GameScene {
    
//    override func update(currentTime: NSTimeInterval) {
//        super.update(currentTime)
//
//        if (Keyboard.sharedKeyboard.justPressed(KeyCode.Space)) {
//            // single key
//        } else if (Keyboard.sharedKeyboard.pressed(KeyCode.Space, KeyCode.Return)) {
//            // two keys
//        } else if (Keyboard.sharedKeyboard.justReleased(KeyCode.Space, KeyCode.W, KeyCode.T, KeyCode.LeftShift)) {
//            // many keys
//        }
//    }
//
//    override func didFinishUpdate() {
//        Keyboard.sharedKeyboard.update()
//    }
//
//    override func keyUp(theEvent: NSEvent) {
//        Keyboard.sharedKeyboard.handleKey(theEvent, isDown: false)
//    }
//
//    override func keyDown(theEvent: NSEvent) {
//        Keyboard.sharedKeyboard.handleKey(theEvent, isDown: true)
//    }

}
#endif

