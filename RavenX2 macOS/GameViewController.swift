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

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = self.view as! SKView
        let scene = GameScene.newGameScene(skView)
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

}

