//
//  MouseManager.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/26/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

class MouseManager {
    
    // MARK: - Properties
    private static var timer: NSTimer? = nil
    
    // MARK: - Public
    class func simulateMouseMovements(delay: Int) {
        if timer != nil {
            endMouseMovements()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(delay),
                                                       target: self,
                                                       selector: #selector(MouseManager.moveMousePointerToRandomPosition),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    class func endMouseMovements() {
        guard timer != nil else {
            return
        }
        timer!.invalidate()
        timer = nil
    }
    
    @objc static func moveMousePointerToRandomPosition() {
        guard let screen = NSScreen.mainScreen() else {
            return
        }
        
        let randomX = CGFloat(random() % Int(screen.visibleFrame.width));
        let randomY = CGFloat(random() % Int(screen.visibleFrame.height));
        let point = CGPointMake(randomX, randomY)
        moveMousePointer(point)
    }
    
    // MARK: - Private
    private static func moveMousePointer(point: CGPoint) {
        CGWarpMouseCursorPosition(point)
        CGAssociateMouseAndMouseCursorPosition(1)
    }
}