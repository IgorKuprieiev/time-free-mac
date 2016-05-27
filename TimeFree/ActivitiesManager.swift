//
//  ActivityManager.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/27/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

class ActivitiesManager: AnyObject {
    
    // MARK: - Properties
    private var globalTimer: NSTimer? = nil
    private let globalTimerTickDuration = 1
    private var globalTickCounter = 0
    private let preferences = Preferences.sharedPreferences
    private lazy var globalMonitors = [AnyObject]()
    
    deinit {
        stopActivities()
    }
    
    // MARK: - Public
    func startActivities() {
        stopActivities()
        
        //Enable a user's observation
        if preferences.automaticallyDisableEventsIfUserIsPresent == true {
            registrationObservers()
        }
        
        globalTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(globalTimerTickDuration),
                                                             target: self,
                                                             selector: #selector(ActivitiesManager.globalTick),
                                                             userInfo: nil,
                                                             repeats: true)
    }
    
    func stopActivities() {
        //Enable Sleep Mode
        PowerManager.enableSleep()
        
        //Turn off a user's observation
        unregisterObservers()
        
        //Reset counter
        globalTickCounter = 0
        
        //Remove timer
        if globalTimer != nil {
            globalTimer!.invalidate()
            globalTimer = nil
        }
    }
    
    @objc func globalTick() {
        globalTickCounter += globalTimerTickDuration
        
        //Enable or disable Sleep Mode
        if preferences.disableSystemSleep == true && PowerManager.isSleepEnabled == true {
            PowerManager.disableSleep()
        } else if preferences.disableSystemSleep == false && PowerManager.isSleepEnabled == false {
            PowerManager.enableSleep()
        }
        
        //Disable the simulation, if there is user activity
        if preferences.automaticallyDisableEventsIfUserIsPresent == true && globalTickCounter < preferences.timeoutOfUserActivity {
            return
        }
        
        //Move mouse
        if preferences.randomlyMovingMousePointer == true && (globalTickCounter % preferences.movingMousePointerDelay) == 0 {
            MouseManager.moveMousePointerToRandomPosition()
        }
    }
    
    // MARK: - Private
    private func registrationObservers() {
        //Action after user activity
        let handler:(NSEvent) -> Void = {[weak self] (event) in
            guard let strongSelf = self else {
                return
            }
            
            //Reset counter
            strongSelf.globalTickCounter = 0
            print("Detect user activity")
        }
        
        //Run monitors
        let eventMasks = [NSEventMask.MouseMovedMask, NSEventMask.ScrollWheelMask]
        for eventMask in eventMasks {
            if let eventMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask(eventMask, handler: handler) {
                globalMonitors.append(eventMonitor)
            }
        }
    }
    
    private func unregisterObservers() {
        for eventMonitor in globalMonitors {
            NSEvent.removeMonitor(eventMonitor)
        }
        globalMonitors.removeAll()
    }
}
