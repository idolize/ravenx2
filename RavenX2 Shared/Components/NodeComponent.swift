//
//  NodeComponent.swift
//  RavenX2
//
//  Created by David Idol on 11/18/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import SpriteKit
import GameplayKit

class NodeComponent: GKComponent {
    let node: SKNode
    
    init(entity: GKEntity, node: SKNode) {
        self.node = node
        super.init()
        node.entity = entity
    }
    
    convenience init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        let node = SKSpriteNode(texture: texture,
                                color: SKColor.white, size: size)
        self.init(entity: entity, node: node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
