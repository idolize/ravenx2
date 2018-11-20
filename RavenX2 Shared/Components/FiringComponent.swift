import Foundation
import SpriteKit
import GameplayKit

class FiringComponent: GKComponent {
    
    var updateTime: TimeInterval = 0
    var isFiring: Bool
    let entityManager: EntityManager
    let firingRate: TimeInterval
    
    init(entityManager: EntityManager, firingRate: TimeInterval = 0.5, firing: Bool = true) {
        self.entityManager = entityManager
        self.firingRate = firingRate
        self.isFiring = firing
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func shoot() {
        guard isFiring == true,
                let selfNode = self.entity?.component(ofType: NodeComponent.self)?.node else {
            // Can't shoot from something that has no location
            return
        }
        var projInitialPosition = CGPoint(x: selfNode.position.x, y: selfNode.position.y)
        if let selfNodeAsSprite = selfNode as? SKSpriteNode {
            projInitialPosition.x += selfNodeAsSprite.size.width / 2
        }
        let projectile = Projectile(team: Team.good, position: projInitialPosition)
        let projectileNode = projectile.node
        projectileNode.zPosition = 1
        
        let projectilePointsPerSecond = CGFloat(500)
        let projectileDistance = CGFloat(1000)
        let duration = projectileDistance / projectilePointsPerSecond
        
        projectile.playSound()
        
        projectileNode.run(SKAction.sequence([
            SKAction.moveBy(x: projectileDistance, y: 0, duration: TimeInterval(duration)),
            SKAction.run() {
                self.entityManager.remove(projectile)
            }
        ]))
        entityManager.add(projectile)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if seconds - updateTime > firingRate {
            shoot()
            updateTime = seconds
        }
        
    }
    
}
