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

    // MARK: - Private Properties
    private var statusItem: NSStatusItem?
    private lazy var trigger = Trigger()
    
    // MARK: - NSApplicationDelegate
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        //Check Grant Access
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
        
        //Customize UI
        prepareStatusItem()
        prepareStatusMenuButtons()
        registrationObservers()
        
        //Disable sleeping(if needed)
        PowerManager.dontAllowSleeping(Preferences.shared.dontAllowSleeping)
        
        //Enable Autolaunching(if needed)
        if Preferences.shared.launchAppAtSystemStartup == true {
            addHelperAppToLoginItems()
        } else {
            removeHelperAppFromLoginItems()
        }
        
        //Start random activities
        prepareAndStartTrigger()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        trigger.stop()
        unregisterObservers()
        PowerManager.dontAllowSleeping(false)
    }
}

extension AppDelegate {
    
    // MARK: - Actions
    @IBAction func dontAllowSleeping(_ sender: AnyObject) {
        Preferences.shared.dontAllowSleeping = !Preferences.shared.dontAllowSleeping
    }
    
    @IBAction func moveMouse(_ sender: NSMenuItem) {
        Preferences.shared.moveMousePointer = !Preferences.shared.moveMousePointer
    }
    
    @IBAction func quit(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
}

extension AppDelegate {
    
    func propertiesHaveBeenUpdated(_ notification: Notification) {
        prepareStatusMenuButtons()
        
        //Sleep Mode
        PowerManager.dontAllowSleeping(Preferences.shared.dontAllowSleeping)
        
        //Autolaunching
        if Preferences.shared.launchAppAtSystemStartup == true {
            addHelperAppToLoginItems()
        } else {
            removeHelperAppFromLoginItems()
        }
    }
    
    // MARK: - Private methods
    private func registrationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AppDelegate.propertiesHaveBeenUpdated(_:)),
                                               name: NSNotification.Name(rawValue: Preferences.NotificationKeys.propertiesHaveBeenUpdatedKey),
                                               object: nil)
    }
    
    private func unregisterObservers() {
        let propertiesHaveBeenUpdatedKey = NSNotification.Name(rawValue: Preferences.NotificationKeys.propertiesHaveBeenUpdatedKey)
        NotificationCenter.default.removeObserver(self, name: propertiesHaveBeenUpdatedKey, object: nil)
    }
}

extension AppDelegate {
    
    private func prepareStatusItem() {
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
    
    private func prepareStatusMenuButtons() {
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
    
    private func prepareAndStartTrigger() {
        trigger.delegate = self
        trigger.timeoutOfUserActivity = Preferences.shared.timeoutOfUserActivity
        trigger.start()
    }
}

extension AppDelegate {
    
    @discardableResult private func checkGrantAccess() -> Bool {
        let trustedCheckOptionPromptString = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        let options: CFDictionary = [trustedCheckOptionPromptString: kCFBooleanTrue]
        
        return AXIsProcessTrustedWithOptions(options)
    }
}

// MARK: - ActivitiesManagerDelegate
extension AppDelegate: TriggerDelegate {
    
    func didStartActivities() {
        NotificationManager.shared.showNotification(title: NSLocalizedString("TimeFree found the lack of user activity", comment: ""))
    }
    
    func didPausedActivities() {
        NotificationManager.shared.showNotification(title: NSLocalizedString("The user has returned", comment: ""))
    }
    
    func triggerTick(trigger: Trigger) {
        //Move mouse
        if Preferences.shared.moveMousePointer == true && (trigger.tickCounter % Preferences.shared.moveMousePointerFrequency) == 0 {
            VirtualMouseManager.shared.moveMousePointerToRandomPosition()
            print("The cursor has been moved to a random location.")
        }
    }
}

