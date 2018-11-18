//
//  Projectile.swift
//  RavenX2
//
//  Created by David Idol on 11/17/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import GameplayKit

class Projectile: GKEntity {
    
    init(team: Team) {
        
        super.init()
        
        let texture = SKTexture(imageNamed: "torpedo")
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        addComponent(TeamComponent(team: team))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
