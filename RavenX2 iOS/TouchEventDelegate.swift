//
//  TouchEventDelegate.swift
//  RavenX2
//
//  Created by David Idol on 11/19/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import SpriteKit
import UIKit

protocol TouchEventDelegate {
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene)
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene)
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene)
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, in scene: SKScene)
    
}
