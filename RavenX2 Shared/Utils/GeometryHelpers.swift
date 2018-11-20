//
//  GeometryHelpers.swift
//  RavenX2
//
//  Created by David Idol on 11/17/18.
//  Copyright © 2018 David Idol. All rights reserved.
//

import CoreGraphics

class GeometryHelpers {
    static func constrainToSize(_ size: CGSize, maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) -> CGSize {
        var newSize = size
        let origWidth = newSize.width;
        if let maxWidthVal = maxWidth, origWidth > maxWidthVal {
            newSize.width = maxWidthVal
            newSize.height = newSize.height * (maxWidthVal / origWidth)
        }
        let origHeight = newSize.height;
        if let maxHeightVal = maxHeight, origHeight > maxHeightVal {
            newSize.height = maxHeightVal
            newSize.width = newSize.width * (maxHeightVal / origHeight)
        }
        return newSize
    }
}
