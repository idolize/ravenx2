//
//  TouchComponent.swift
//  RavenX2 iOS
//
//  Created by David Idol on 11/18/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import GameplayKit

class TouchComponent: GKComponent, TouchEventDelegate {
    var lastTouchLocation: CGPoint?
    let eventDelegate: TouchEventDelegate?
    
    var isTouching: Bool {
        return lastTouchLocation != nil
    }
    
    init(_ eventDelegate: TouchEventDelegate? = nil) {
        self.eventDelegate = eventDelegate
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
        lastTouchLocation = touches.first?.location(in: scene)
        eventDelegate?.touchesBegan(touches, with: event, in: scene)
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
        lastTouchLocation = touches.first?.location(in: scene)
        eventDelegate?.touchesMoved(touches, with: event, in: scene)
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
        lastTouchLocation = nil
        eventDelegate?.touchesEnded(touches, with: event, in: scene)
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene) {
        lastTouchLocation = nil
        eventDelegate?.touchesCancelled(touches, with: event, in: scene)
    }
}
