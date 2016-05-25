//
//  AppDelegate.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/25/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa
import CoreGraphics

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Outlets
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    // MARK: - Properties
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)

    // MARK: - NSApplicationDelegate
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        personalizeStatusItem()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    // MARK: - IBActions
    @IBAction func startOrStop(sender: AnyObject) {
        let point = CGPointMake(100, 100)
        CGWarpMouseCursorPosition(point)
        CGAssociateMouseAndMouseCursorPosition(1)
    }
    
    @IBAction func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    
    // MARK: - Private
    func personalizeStatusItem() {
        statusItem.image = NSImage(named: "spy")
        statusItem.menu = statusMenu
    }
    
}

