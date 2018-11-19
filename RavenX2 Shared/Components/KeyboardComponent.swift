//
//  KeyboardComponent.swift
//  RavenX2 macOS
//
//  Created by David Idol on 11/18/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import GameplayKit

class KeyboardComponent: GKComponent {
    let keyboard = Keyboard()
    
    func handleKey(_ theEvent: NSEvent, isDown: Bool) {
        keyboard.handleKey(event: theEvent, isDown: isDown)
    }
}
