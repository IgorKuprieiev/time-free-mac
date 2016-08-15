//
//  MouseManager.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/26/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

final class VirtualMouseManager {
    
    // MARK: - Singletone Implementation
    static let shared: VirtualMouseManager = VirtualMouseManager()
    
    // MARK: - Private Properties
    private lazy var virtualMouse: VirtualMouse? = VirtualMouse()
    
    // MARK: - Public
    func moveMousePointerToRandomPosition() {
        guard let screen = NSScreen.main() else {
            return
        }

        let x = arc4random_uniform(UInt32(screen.visibleFrame.width))
        let y = arc4random_uniform(UInt32(screen.visibleFrame.height))
        virtualMouse?.movePointerTo(x: x, y: y)
        print("The cursor has been moved to a random location.")
    }
}
