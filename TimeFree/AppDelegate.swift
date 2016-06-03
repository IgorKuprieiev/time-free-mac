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
    @IBOutlet weak var statusMenu: NSMenu? {
        didSet {
            statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
            statusItem!.menu = statusMenu
        }
    }
    
    // MARK: - Properties
    private var statusItem: NSStatusItem?
    private lazy var activitiesManager = ActivitiesManager()
    private lazy var preferences = Preferences.sharedPreferences

    // MARK: - NSApplicationDelegate
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        updateStatusItemIconAndMenuButtons()
        registrationObservers()
        PowerManager.dontAllowSleeping(preferences.dontAllowSleeping)
        activitiesManager.startActivities()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        activitiesManager.stopActivities()
        unregisterObservers()
        PowerManager.dontAllowSleeping(false)
    }

    // MARK: - IBActions
    @IBAction func dontAllowSleeping(sender: AnyObject) {
        preferences.dontAllowSleeping = !preferences.dontAllowSleeping
    }
    
    @IBAction func moveMouse(sender: NSMenuItem) {
        preferences.moveMousePointer = !preferences.moveMousePointer
    }

    @IBAction func runScripts(sender: NSMenuItem) {
        preferences.runScripts = !preferences.runScripts
    }

    @IBAction func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    // MARK: - Private
    private func registrationObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(AppDelegate.propertiesHaveBeenUpdated(_:)),
                                                         name: Preferences.NotificationKeys.propertiesHaveBeenUpdatedKey,
                                                         object: nil)
    }
    
    private func unregisterObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Preferences.NotificationKeys.propertiesHaveBeenUpdatedKey, object: nil)
    }
    
    func propertiesHaveBeenUpdated(notification: NSNotification) {
        updateStatusItemIconAndMenuButtons()
        PowerManager.dontAllowSleeping(preferences.dontAllowSleeping)
    }

    private func updateStatusItemIconAndMenuButtons() {
        //set icon
        if let statusItem = statusItem {
            let statusItemImageName = "spy"
            statusItem.image = NSImage(named: statusItemImageName)
        }
        
        //set names for items
        if let statusMenu = statusMenu {
            if let dontAllowSleepingItem = statusMenu.itemAtIndex(0) {
                dontAllowSleepingItem.state = preferences.dontAllowSleeping == true ? 1 : 0
            }
            
            if let moveMousePointerItem = statusMenu.itemAtIndex(1) {
                moveMousePointerItem.state = preferences.moveMousePointer == true ? 1 : 0
            }
            
            if let runScriptsItem = statusMenu.itemAtIndex(2) {
                runScriptsItem.state = preferences.runScripts == true ? 1 : 0
            }
        }
    }
}

