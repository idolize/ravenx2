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
    
    var animationComponent: AnimatedSpriteComponent? {
        return component(ofType: AnimatedSpriteComponent.self)
    }
    
    // This is needed because we can't call convenience initializers in subclasses :(
    private static func initHelper(_ instance: EntityWithSpriteComponent, texture: SKTexture, size: CGSize? = nil, maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        let adjustedSize = GeometryHelpers.constrainToSize(size ?? texture.size(), maxWidth: maxWidth, maxHeight: maxHeight)
        let spriteComponent = NodeComponent(entity: instance, texture: texture, size: adjustedSize)
        instance.addComponent(spriteComponent)
    }
    
    init(_ node: SKSpriteNode) {
        super.init()
        let spriteComponent = NodeComponent(entity: self, node: node)
        addComponent(spriteComponent)
    }

    init(texture: SKTexture, size: CGSize? = nil, maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        super.init()
        EntityWithSpriteComponent.initHelper(self, texture: texture, size: size, maxWidth: maxWidth, maxHeight: maxHeight)
    }
    
    init(textureAtlas: String, size: CGSize? = nil, maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil, animateForever: Bool = true, timePerFrame: TimeInterval? = nil) {
        super.init()
        let animationComponent = timePerFrame == nil ?
            AnimatedSpriteComponent(atlasName: textureAtlas) :
            AnimatedSpriteComponent(atlasName: textureAtlas, timePerFrame: timePerFrame!)
        let firstFrameTexture = animationComponent.posterFrame
        EntityWithSpriteComponent.initHelper(self, texture: firstFrameTexture, size: size, maxWidth: maxWidth, maxHeight: maxHeight)
        addComponent(animationComponent)
        if animateForever {
            animationComponent.animateForever(node: self.node)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
