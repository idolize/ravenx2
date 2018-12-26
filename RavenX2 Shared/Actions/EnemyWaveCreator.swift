import SpriteKit

class EnemyWaveCreator {
    private let enemyManager: EnemyManager
    
    init(enemyManager: EnemyManager) {
        self.enemyManager = enemyManager
    }
    
    func createWaveAction(numEnemies: Int) -> SKAction {
        var actions: [SKAction] = []
        for i in 0...numEnemies {
            actions.append(SKAction.run {
                self.enemyManager.spawnEnemy1()
            })
            if i < numEnemies - 1 {
                actions.append(SKAction.wait(forDuration: 1))
            }
        }
        return SKAction.sequence(actions)
    }
    
}
