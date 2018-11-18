//
//  GeometryHelpers.swift
//  RavenX2
//
//  Created by David Idol on 11/17/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import CoreGraphics

class GeometryHelpers {
    static func constrainSizeToWidth(_ size: CGSize, maxWidth: CGFloat) -> CGSize {
        let origWidth = size.width;
        if origWidth > maxWidth {
            return CGSize(width: maxWidth, height: size.height * (maxWidth / origWidth))
        }
        return size
    }
    
    static func constrainSizeToHeight(_ size: CGSize, maxHeight: CGFloat) -> CGSize {
        let origHeight = size.width;
        if origHeight > maxHeight {
            return CGSize(width: size.width * (maxHeight / origHeight), height: maxHeight)
        }
        return size
    }
}
