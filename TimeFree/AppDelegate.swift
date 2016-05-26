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
    
    // MARK: - Properties
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    
    // MARK: - NSApplicationDelegate
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        personalizeStatusItem()
        updateIconsAndMenuButtons()
        reloadManagers()
        registrationObservers()
        
        NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.MouseMovedMask) { (event) in
            print(event)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        unregisterObservers()
        stopManagers()
    }

    // MARK: - IBActions
    @IBAction func startOrStop(sender: AnyObject) {
        let preferences = Preferences.sharedPreferences
        preferences.enableManagers = !preferences.enableManagers
    }
    
    @IBAction func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    // MARK: - Private
    private func personalizeStatusItem() {
        statusItem.menu = statusMenu
    }
    
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
        reloadManagers()
        updateIconsAndMenuButtons()
    }

    private func reloadManagers() {
        stopManagers()
        
        let preferences = Preferences.sharedPreferences

        guard preferences.enableManagers == true else {
            return
        }
        
        print("Start managers")
        
        if preferences.disableSystemSleep == true {
            PowerManager.disableSleep()
        }
        
        if preferences.randomlyMovingMousePointer == true && preferences.movingMousePointerDelay > 0 {
            MouseManager.simulateMouseMovements(preferences.movingMousePointerDelay)
        }
        
    }
    
    private func stopManagers() {
        print("Stop managers")
        PowerManager.enableSleep()
        MouseManager.endMouseMovements()
    }
    
    private func updateIconsAndMenuButtons() {
        let preferences = Preferences.sharedPreferences
        
        //set icon
        let statusItemImageName = preferences.enableManagers == true ? "spy1" : "spy"
        statusItem.image = NSImage(named: statusItemImageName)
        
        //set names for items
        if let statusMenu = statusMenu, let startOrStopItem = statusMenu.itemAtIndex(0) {
            startOrStopItem.title = preferences.enableManagers == true ? NSLocalizedString("Stop simulation", comment: "") : NSLocalizedString("Start simulation", comment: "")
        }
    }
}

