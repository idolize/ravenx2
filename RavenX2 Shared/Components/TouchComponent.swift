//
//  TouchComponent.swift
//  RavenX2 iOS
//
//  Created by David Idol on 11/18/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import GameplayKit

class TouchComponent: GKComponent {
    var lastTouchLocation: CGPoint?
    
    var isTouching: Bool {
        return lastTouchLocation != nil
    }

    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
        lastTouchLocation = touches.first?.location(in: scene)
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
        lastTouchLocation = touches.first?.location(in: scene)
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
        lastTouchLocation = nil
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
        lastTouchLocation = nil
    }
}
