import Foundation
import SpriteKit
import GameplayKit

class FiringComponent: GKComponent {
    
    var updateTime: TimeInterval = 0
    let entityManager: EntityManager
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func shoot() {
        // TODO best way to handle sound effects?
//        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let torpedo = Projectile(team: Team.good)
        guard let torpedoNode = torpedo.component(ofType: SpriteComponent.self)?.node,
            let selfNode = self.entity?.component(ofType: SpriteComponent.self)?.node else {
            return
        }
        torpedoNode.position = selfNode.position
        torpedoNode.position.x += (selfNode.size.width / 2) + (torpedoNode.size.width / 2)
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = PhysicsType.Projectile
        torpedoNode.physicsBody?.contactTestBitMask = PhysicsType.Enemy
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        let torpedoPointsPerSecond = CGFloat(300)
        let torpedoDistance = CGFloat(1000)
        let duration = torpedoDistance / torpedoPointsPerSecond
        
        torpedoNode.zPosition = 1
        
        torpedoNode.run(SKAction.sequence([
            SKAction.moveBy(x: torpedoDistance, y: 0, duration: TimeInterval(duration)),
            SKAction.run() {
                self.entityManager.remove(torpedo)
            }
        ]))
        entityManager.add(torpedo)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if updateTime == 0 {
            updateTime = seconds
        }
        
        if seconds - updateTime > 1 {
            shoot()
            updateTime = seconds
        }
        
    }
    
}
