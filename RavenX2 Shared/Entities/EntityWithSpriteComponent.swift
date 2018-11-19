//
//  EntityWithSpriteComponent.swift
//  RavenX2
//
//  Created by David Idol on 11/18/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import GameplayKit
import SpriteKit

class EntityWithSpriteComponent: GKEntity {
    var node: SKSpriteNode {
        return component(ofType: NodeComponent.self)!.node as! SKSpriteNode
    }
    
    init(_ node: SKSpriteNode) {
        super.init()
        let spriteComponent = NodeComponent(entity: self, node: node)
        addComponent(spriteComponent)
    }

    init(texture: SKTexture, size: CGSize) {
        super.init()
        let spriteComponent = NodeComponent(entity: self, texture: texture, size: size)
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
