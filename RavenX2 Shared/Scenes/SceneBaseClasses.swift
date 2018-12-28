//
//  Scene.swift
//  RavenX2
//
//  Created by David Idol on 11/20/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import SpriteKit
import GameKit

@discardableResult
private func initializeScene<T: BaseScene>(_ scene: T, sceneState: GKStateMachine) -> T {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    scene.sceneState = sceneState
    return scene
}


class BaseScene: SKScene {
    var sceneState: GKStateMachine!
    
    init(game: GameState) {
        super.init(size: game.view.bounds.size)
        initializeScene(self, sceneState: game.sceneState)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class SceneFromFile: BaseScene {
    class func newScene<T: BaseScene>(game: GameState) -> T {
        let sceneFile = (NSStringFromClass(self) as NSString).components(separatedBy: ".").last!
        guard let scene = SKScene(fileNamed: sceneFile) as? T else {
            fatalError("Failed to load Scene from file \(sceneFile)")
        }
        scene.size = game.view.bounds.size
        return initializeScene(scene, sceneState: game.sceneState)
    }
    
    private override init(game: GameState) {
        // Should not be called
        super.init(game: game)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
