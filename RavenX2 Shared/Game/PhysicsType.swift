//
//  PhysicsType.swift
//  RavenX2
//
//  Created by David Idol on 11/17/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

// Bitmask -- 0 and UInt32.max have special meanings, everything else
// should be a unique collision type for detection by the physics engine
struct PhysicsType {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Player    : UInt32 = 0x1 << 0
    static let Enemy     : UInt32 = 0x1 << 1
    static let Projectile: UInt32 = 0x1 << 2
}
