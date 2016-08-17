//
//  ServicesManager.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 8/16/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

class ServicesManager {

    // MARK: - Private Properties
    lazy var timeCounter: TimeCounter? = TimeCounter(delegate: self)
    lazy var powerService: PowerService? = PowerService()
    lazy var eventTracker: EventTracker? = EventTracker(delegate: self)
    lazy var mouseService: MouseService? = MouseService()
    
    // MARK: - Public Properties
    func resetAllServices() {
        resetTimeCounter()
        resetPowerService()
        resetEventTracker()
        resetAutolaunchService()
    }
    
    func resetTimeCounter() {
        timeCounter?.reset()
    }
    
    func resetPowerService() {
        if Preferences.shared.dontAllowSleeping == true {
            powerService?.powerMode = .disableSleeping
        } else {
            powerService?.powerMode = .governedBySystem
        }
    }
    
    func resetEventTracker() {
        if Preferences.shared.timeoutOfUserActivity > 0 {
            eventTracker?.startTracking()
        } else {
            eventTracker?.stopTracking()
        }
    }
    
    func resetAutolaunchService() {
        if Preferences.shared.launchAppAtSystemStartup == true {
            addHelperAppToLoginItems()
        } else {
            removeHelperAppFromLoginItems()
        }
    }
}

extension ServicesManager: TimeCounterDelegate {
    
    func didTick(_ tickCount: UInt64) {
        let timeoutOfUserActivity = UInt64(Preferences.shared.timeoutOfUserActivity)
        guard tickCount >= timeoutOfUserActivity else {
            return
        }
        
        guard Preferences.shared.moveMousePointer == true else {
            return
        }
        
        if timeoutOfUserActivity > 0 && tickCount == timeoutOfUserActivity {
            print("Run activity imitation")
            if Preferences.shared.showNotifications == true {
                NotificationManager.shared.showNotification(title: "No user activity.", details: "Run activity imitation.")
            } else {
                NotificationManager.shared.playSoundNotification()
            }
        }
        
        if tickCount % UInt64(Preferences.shared.moveMousePointerFrequency) == 0 {
            mouseService?.moveMousePointerToRandomPosition()
        }
    }
}

extension ServicesManager: EventTrackerDelegate {
    
    func didReceiveEvent(_ event: NSEvent) {
        guard event.deviceID != 0 else {
            print("Detect event from Virtual Device")
            return
        }
        
        let timeoutOfUserActivity = UInt64(Preferences.shared.timeoutOfUserActivity)
        let currentTickCount = (timeCounter?.tickCount)!
        if timeoutOfUserActivity > 0 && currentTickCount > timeoutOfUserActivity {
            print("Activity imitation interrupted.")
            if Preferences.shared.showNotifications == true {
                NotificationManager.shared.showNotification(title: "User is back.", details: "Activity imitation interrupted.")
            } else {
                 NotificationManager.shared.playSoundNotification()
            }
        }
        
        timeCounter?.resetTickCount()
    }
}

