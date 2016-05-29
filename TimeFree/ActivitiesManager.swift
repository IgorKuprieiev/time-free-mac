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
    private var timer: NSTimer? = nil
    private let timerTickDuration = 1
    private var tickCounter = 0
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
        
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(timerTickDuration),
                                                       target: self,
                                                       selector: #selector(ActivitiesManager.tick),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    func stopActivities() {
        //Enable Sleep Mode
        PowerManager.enableSleep()
        
        //Turn off a user's observation
        unregisterObservers()
        
        //Reset counter
        tickCounter = 0
        
        //Remove timer
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    @objc func tick() {
        tickCounter += timerTickDuration
        
        //Enable or disable Sleep Mode
        if preferences.disableSystemSleep == true && PowerManager.isSleepEnabled == true {
            PowerManager.disableSleep()
        } else if preferences.disableSystemSleep == false && PowerManager.isSleepEnabled == false {
            PowerManager.enableSleep()
        }
        
        //Disable the simulation, if there is user activity
        if preferences.automaticallyDisableEventsIfUserIsPresent == true && tickCounter < preferences.timeoutOfUserActivity {
            return
        }
        
        //Move mouse
        if preferences.randomlyMovingMousePointer == true && (tickCounter % preferences.movingMousePointerDelay) == 0 {
            MouseManager.moveMousePointerToRandomPosition()
        }
        
        //Run script
        if preferences.scripts.count > 0 && (tickCounter % preferences.movingMousePointerDelay) == 0 {
            preferences.scripts.randomItem().runScript()
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
            strongSelf.tickCounter = 0
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
