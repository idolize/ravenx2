//
//  SceneManager.swift
//  RavenX2
//
//  Created by David Idol on 11/20/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import GameplayKit

internal class SceneState<T: BaseScene>: GKState {
    internal let game: GameState!
    
    init(_ game: GameState) {
        self.game = game
    }
    
    func enterSceneForState(scene: T) {
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        game.view.presentScene(scene, transition: transition)
    }
}

class MenuSceneState: SceneState<MenuScene> {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        enterSceneForState(scene: MenuScene.newScene(game: game))
    }
}
class GameSceneState: SceneState<GameScene> {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is MenuSceneState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        enterSceneForState(scene: GameScene(game: game))
    }
}

class GameState {
    let view: SKView!
    var sceneState: GKStateMachine!
    
    init(view: SKView) {
        self.view = view
        sceneState = GKStateMachine(states: [
            MenuSceneState(self),
            GameSceneState(self),
        ])
    }
    
    func startGame() {
        // Start with the menu scene
        sceneState.enter(MenuSceneState.self)
    }
}
