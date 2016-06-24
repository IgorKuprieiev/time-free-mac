//
//  MouseManager.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/26/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

class MouseManager {
    
    // MARK: - Public
    class func moveMousePointerToRandomPosition() {
        guard let screen = NSScreen.main() else {
            return
        }

        let randomX = CGFloat(arc4random_uniform(UInt32(screen.visibleFrame.width)))
        let randomY = CGFloat(arc4random_uniform(UInt32(screen.visibleFrame.height)))
        let point = CGPoint(x: randomX, y: randomY)
        moveMousePointer(point)
        print("The cursor has been moved to a random location.")
    }

    class func moveMousePointer(_ point: CGPoint) {
        CGWarpMouseCursorPosition(point)
        CGAssociateMouseAndMouseCursorPosition(1)
    }
}
