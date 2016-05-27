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
        if preferences.enableManagers == true {
            activitiesManager.startActivities()
        }
        updateStatusItemIconAndMenuButtons()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        activitiesManager.stopActivities()
    }

    // MARK: - IBActions
    @IBAction func startOrStop(sender: AnyObject) {
        preferences.enableManagers = !preferences.enableManagers
        if preferences.enableManagers == true {
            activitiesManager.startActivities()
        } else {
            activitiesManager.stopActivities()
        }
        updateStatusItemIconAndMenuButtons()
    }
    
    @IBAction func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    // MARK: - Private
    private func updateStatusItemIconAndMenuButtons() {
        //set icon
        if let statusItem = statusItem {
            let statusItemImageName = preferences.enableManagers == true ? "spy1" : "spy"
            statusItem.image = NSImage(named: statusItemImageName)
        }
        
        //set names for items
        if let statusMenu = statusMenu, let startOrStopItem = statusMenu.itemAtIndex(0) {
            startOrStopItem.title = preferences.enableManagers == true ? NSLocalizedString("Stop simulation", comment: "") : NSLocalizedString("Start simulation", comment: "")
        }
    }
}

