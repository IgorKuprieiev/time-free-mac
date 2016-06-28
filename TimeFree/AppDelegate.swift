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
    private lazy var preferences = Preferences.sharedPreferences

    // MARK: - NSApplicationDelegate
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //Customize UI
        prepareStatusItem()
        prepareStatusMenuButtons()
        registrationObservers()
        
        //Disable slipping(if needed)
        PowerManager.dontAllowSleeping(preferences.dontAllowSleeping)
        
        //Start random activities
        prepareAndStartTrigger()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        trigger.stop()
        unregisterObservers()
        PowerManager.dontAllowSleeping(false)
    }

    // MARK: - Actions
    @IBAction func dontAllowSleeping(_ sender: AnyObject) {
        preferences.dontAllowSleeping = !preferences.dontAllowSleeping
    }
    
    @IBAction func moveMouse(_ sender: NSMenuItem) {
        preferences.moveMousePointer = !preferences.moveMousePointer
    }

    @IBAction func runScripts(_ sender: NSMenuItem) {
        preferences.runScripts = !preferences.runScripts
    }

    @IBAction func quit(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    func propertiesHaveBeenUpdated(_ notification: Notification) {
        prepareStatusMenuButtons()
        PowerManager.dontAllowSleeping(preferences.dontAllowSleeping)
    }
    
    // MARK: - Private methods
    private func registrationObservers() {
        NotificationCenter.default().addObserver(self,
                                                 selector: #selector(AppDelegate.propertiesHaveBeenUpdated(_:)),
                                                 name: Preferences.NotificationKeys.propertiesHaveBeenUpdatedKey,
                                                 object: nil)
    }
    
    private func unregisterObservers() {
        let propertiesHaveBeenUpdatedKey = NSNotification.Name(rawValue: Preferences.NotificationKeys.propertiesHaveBeenUpdatedKey)
        NotificationCenter.default().removeObserver(self, name: propertiesHaveBeenUpdatedKey, object: nil)
    }
    
    private func prepareAndStartTrigger() {
        trigger.delegate = self
        trigger.timeoutOfUserActivity = preferences.timeoutOfUserActivity
        trigger.start()
    }
    
    private func prepareStatusItem() {
        guard let statusMenu = statusMenu else {
            return
        }
        
        statusItem = NSStatusBar.system().statusItem(withLength: -2)
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
            dontAllowSleepingItem.state = preferences.dontAllowSleeping == true ? NSOnState : NSOffState
        }
        
        if let moveMousePointerItem = statusMenu.item(at: 1) {
            moveMousePointerItem.state = preferences.moveMousePointer == true ? NSOnState : NSOffState
        }
        
        if let runScriptsItem = statusMenu.item(at: 2) {
            runScriptsItem.state = preferences.runScripts == true ? NSOnState : NSOffState
        }
    }
}

// MARK: - ActivitiesManagerDelegate
extension AppDelegate: TriggerDelegate {
    
    func didStartActivities() {
        NSSound(named: "Hero")?.play()
        print("didStartActivities")
    }
    
    func didPausedActivities() {
        print("didPausedActivities")
    }
    
    func triggerTick(trigger: Trigger) {
        print("triggerTick")

        //Move mouse
        if preferences.moveMousePointer == true && (trigger.tickCounter % preferences.moveMousePointerFrequency) == 0 {
            MouseManager.moveMousePointerToRandomPosition()
        }
        
        //Run script
        if preferences.runScripts == true && (trigger.tickCounter % preferences.runScriptsFrequency) == 0 {
            let enabledScripts = preferences.scripts.filter({ (script) -> Bool in
                return script.scriptEnabled
            })
            if enabledScripts.count > 0 {
                preferences.scripts.randomItem().runScript()
            }
        }

    }
}


