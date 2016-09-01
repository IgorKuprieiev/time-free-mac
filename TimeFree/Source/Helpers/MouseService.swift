//
//  MouseService.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/26/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

final class MouseService {
    
    // MARK: - Private Properties
    fileprivate lazy var virtualMouse: VirtualMouse? = VirtualMouse()
    
    // MARK: - Public
    func moveMousePointerToRandomPosition() {
        guard let screen = NSScreen.main() else {
            return
        }

        guard let virtualMouse = virtualMouse else {
            return
        }
        
        let x = arc4random_uniform(UInt32(screen.visibleFrame.width))
        let y = arc4random_uniform(UInt32(screen.visibleFrame.height))
        if virtualMouse.movePointerTo(x: x, y: y) == true {
            print("The cursor has been moved to a random location.")
        }
    }
}
