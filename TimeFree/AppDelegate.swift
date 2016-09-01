//
//  AppDelegate.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/25/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

@NSApplicationMain

// MARK: - ActivitiesManager
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Outlets
    @IBOutlet weak var statusMenu: NSMenu?

    // MARK: - Properties
    var statusItem: NSStatusItem?
    lazy var servicesManager = ServicesManager()
    
    // MARK: - NSApplicationDelegate
    func applicationWillFinishLaunching(_ notification: Notification) {
        checkGrantAccess()
        if checkGrantAccess() == false {
            let alert = NSAlert()
            alert.messageText = "TimeFree needs your permission to run"
            alert.informativeText = "Enable TimeFree in Security & Privacy preferences -> Privacy -> Accessibility, in System Preferences.\nThen restart TimeFree."
            alert.alertStyle = .critical
            alert.addButton(withTitle: "Exit & Open System Preferences")
            alert.addButton(withTitle: "Exit")
            
            switch alert.runModal() {
            case NSAlertFirstButtonReturn:
                NSWorkspace.shared().openFile("/System/Library/PreferencePanes/Security.prefPane")
                fallthrough
            default:
                NSApp.terminate(nil)
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //Customize UI
        prepareStatusItem()
        prepareStatusMenuButtons()
        servicesManager.resetAllServices()
    }
}

extension AppDelegate {
    
    // MARK: - Actions
    @IBAction func dontAllowSleeping(_ sender: AnyObject) {
        Preferences.shared.dontAllowSleeping = !Preferences.shared.dontAllowSleeping
        servicesManager.resetPowerService()
        updateStatusMenuButtons()
    }
    
    @IBAction func moveMouse(_ sender: NSMenuItem) {
        Preferences.shared.moveMousePointer = !Preferences.shared.moveMousePointer
        updateStatusMenuButtons()
    }
    
    @IBAction func quit(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
}

extension AppDelegate {
    
    fileprivate func prepareStatusItem() {
        guard let statusMenu = statusMenu else {
            return
        }
        
        statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        statusItem?.menu = statusMenu
        if let statusItemImage = NSImage(named: "clock_color_icon") {
            statusItem?.image = statusItemImage
            statusItem?.alternateImage = statusItemImage
        }
    }
    
    fileprivate func updateStatusMenuButtons() {
        prepareStatusMenuButtons()
    }
    
    fileprivate func prepareStatusMenuButtons() {
        guard let statusMenu = statusMenu else {
            return
        }
        
        if let dontAllowSleepingItem = statusMenu.item(at: 0) {
            dontAllowSleepingItem.state = Preferences.shared.dontAllowSleeping == true ? NSOnState : NSOffState
        }
        
        if let moveMousePointerItem = statusMenu.item(at: 1) {
            moveMousePointerItem.state = Preferences.shared.moveMousePointer == true ? NSOnState : NSOffState
        }
        
    }
}

extension AppDelegate {
    
    @discardableResult func checkGrantAccess() -> Bool {
        let trustedCheckOptionPromptString = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        let options = [trustedCheckOptionPromptString: kCFBooleanTrue] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }
}

