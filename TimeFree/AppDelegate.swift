//
//  AppDelegate.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/25/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Outlets
    @IBOutlet weak var statusMenu: NSMenu?

    // MARK: - Private Properties
    private var statusItem: NSStatusItem?
    private lazy var activitiesManager = ActivitiesManager()
    private lazy var preferences = Preferences.sharedPreferences

    // MARK: - NSApplicationDelegate
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        prepareStatusItem()
        updateStatusItemIconAndMenuButtons()
        registrationObservers()
        PowerManager.dontAllowSleeping(preferences.dontAllowSleeping)
        activitiesManager.startActivities()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        activitiesManager.stopActivities()
        unregisterObservers()
        PowerManager.dontAllowSleeping(false)
    }

    // MARK: - IBActions
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
    
    // MARK: - Actions
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
    
    func prepareStatusItem() {
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


