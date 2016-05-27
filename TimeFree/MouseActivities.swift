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
        guard let screen = NSScreen.mainScreen() else {
            return
        }
        
        let randomX = CGFloat(random() % Int(screen.visibleFrame.width));
        let randomY = CGFloat(random() % Int(screen.visibleFrame.height));
        let point = CGPointMake(randomX, randomY)
        moveMousePointer(point)
        print("The cursor has been moved to a random location")
    }

    class func moveMousePointer(point: CGPoint) {
        CGWarpMouseCursorPosition(point)
        CGAssociateMouseAndMouseCursorPosition(1)
    }
}