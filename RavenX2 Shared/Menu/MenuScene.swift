//
//  MenuScene.swift
//  RavenX2
//
//  Created by David Idol on 11/15/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import SpriteKit

class MenuScene: SceneFromFile {
    
    var newGameButtonNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "newGameButton" {
                sceneState.enter(GameSceneState.self)
            }
            
        }
    }

}
