//
//  Explosion.swift
//  RavenX2
//
//  Created by David Idol on 11/18/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import GameplayKit

class Explosion: GKEntity {
    let entityManager: EntityManager!
    
    var node: SKEmitterNode {
        return component(ofType: NodeComponent.self)!.node as! SKEmitterNode
    }
    
    init(entityManager: EntityManager, position: CGPoint) {
        self.entityManager = entityManager
        super.init()
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = position
        let emitterComponent = NodeComponent(entity: self, node: explosion)
        addComponent(emitterComponent)

        // TODO sound
        // self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        explosion.run(SKAction.wait(forDuration: 2)) {
            self.entityManager.remove(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
