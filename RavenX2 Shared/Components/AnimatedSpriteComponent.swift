//
//  AnimatedSpriteComponent.swift
//  RavenX2
//
//  Created by David Idol on 11/18/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import GameKit

class AnimatedSpriteComponent: GKComponent {
    let atlasName: String
    let frames: [SKTexture]
    let timePerFrame: TimeInterval
    
    var posterFrame: SKTexture {
        return frames.first!
    }
    
    private var node: SKNode?
    
    init(atlasName: String, timePerFrame: TimeInterval = 0.05) {
        self.atlasName = atlasName
        self.timePerFrame = timePerFrame
        let animatedAtlas = SKTextureAtlas(named: atlasName)
        var frames: [SKTexture] = []
        for i in 1...animatedAtlas.textureNames.count {
            let textureName = "\(atlasName)\(i)"
            frames.append(animatedAtlas.textureNamed(textureName))
        }
        self.frames = frames
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateForever(node: SKNode) {
        self.node = node
        // Run action forever
        node.run(SKAction.repeatForever(
            SKAction.animate(
                with: frames,
                timePerFrame: timePerFrame,
                resize: false,
                restore: true
            )
        ), withKey: atlasName)
    }
    
    func animateOnce(node: SKNode) {
        // Stop any existing action on this node first
        self.node?.removeAction(forKey: atlasName)
        self.node = node
        node.removeAction(forKey: atlasName)
        // Run action once
        node.run(SKAction.animate(
            with: frames,
            timePerFrame: timePerFrame,
            resize: false,
            restore: false
        ), withKey: atlasName)
    }
    
    deinit {
        node?.removeAction(forKey: atlasName)
    }
}
