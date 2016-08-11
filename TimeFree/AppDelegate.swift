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
    @IBOutlet weak var preferencesWindowController: NSWindowController?

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
        
        //Create directory for Users Scripts
        createDirectioryForUsersScripts()
        
        //Customize UI
        prepareStatusItem()
        prepareStatusMenuButtons()
        registrationObservers()
        
        //Disable sleeping(if needed)
        PowerManager.dontAllowSleeping(Preferences.shared.dontAllowSleeping)
        
        //Enable Autolaunching(if needed)
        if Preferences.shared.autoLaunch == true {
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
    
    @IBAction func runScripts(_ sender: NSMenuItem) {
        Preferences.shared.runScripts = !Preferences.shared.runScripts
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
        if Preferences.shared.autoLaunch == true {
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
            dontAllowSleepingItem.state = Preferences.shared.dontAllowSleeping == true ? NSOnState : NSOffState
        }
        
        if let moveMousePointerItem = statusMenu.item(at: 1) {
            moveMousePointerItem.state = Preferences.shared.moveMousePointer == true ? NSOnState : NSOffState
        }
        
        if let runScriptsItem = statusMenu.item(at: 2) {
            runScriptsItem.state = Preferences.shared.runScripts == true ? NSOnState : NSOffState
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

extension AppDelegate {
    
    func createDirectioryForUsersScripts() {
        guard let usersScriptsPath = Preferences.usersScriptsPath() else {
            return
        }
        guard FileManager.default.fileExists(atPath: usersScriptsPath) == false else {
            return
        }
        do {
            try FileManager.default.createDirectory(atPath: usersScriptsPath, withIntermediateDirectories: true, attributes: nil)
        }  catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

// MARK: - ActivitiesManagerDelegate
extension AppDelegate: TriggerDelegate {
    
    func didStartActivities() {
        NotificationManager.shared.showNotification(title: NSLocalizedString("TimeFree found the lack of user activity", comment: ""),
                                                    informativeText: NSLocalizedString("", comment: ""))
        print("didStartActivities")
    }
    
    func didPausedActivities() {
        NotificationManager.shared.showNotification(title: NSLocalizedString("The user has returned", comment: ""),
                                                    informativeText: NSLocalizedString("", comment: ""))

        print("didPausedActivities")
    }
    
    func triggerTick(trigger: Trigger) {
        print("triggerTick")

        //Move mouse
        if Preferences.shared.moveMousePointer == true && (trigger.tickCounter % Preferences.shared.moveMousePointerFrequency) == 0 {
            MouseManager.moveMousePointerToRandomPosition()
        }
        
        //Run script
        if Preferences.shared.runScripts == true && (trigger.tickCounter % Preferences.shared.runScriptsFrequency) == 0 {
            let enabledScripts = Preferences.shared.scripts.filter({ (script) -> Bool in
                return script.scriptEnabled
            })
            if enabledScripts.count > 0 {
                Preferences.shared.scripts.randomItem().runScript()
            }
        }
    }
}

