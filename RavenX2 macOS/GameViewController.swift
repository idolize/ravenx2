//
//  GameViewController.swift
//  RavenX2 macOS
//
//  Created by David Idol on 11/15/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

let aspectRatio = NSSize(width: 19.5, height: 9)

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        let game = GameState(view: skView)
        game.startGame()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.contentAspectRatio = aspectRatio
    }
}

