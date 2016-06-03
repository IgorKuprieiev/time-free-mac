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
    private let timerTickDuration = 5
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
        if preferences.timeoutOfUserActivity > 0 {
            registrationObservers()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(timerTickDuration),
                                                       target: self,
                                                       selector: #selector(ActivitiesManager.tick),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    func stopActivities() {
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
        
        //Disable the simulation, if there is user activity
        if tickCounter < preferences.timeoutOfUserActivity {
            return
        }
        
        //Move mouse
        if preferences.moveMousePointer == true && (tickCounter % preferences.moveMousePointerFrequency) == 0 {
            MouseManager.moveMousePointerToRandomPosition()
        }
        
        //Run script
        if preferences.runScripts == true && (tickCounter % preferences.runScriptsFrequency) == 0 {
            let enabledScripts = preferences.scripts.filter({ (script) -> Bool in
                return script.scriptEnabled
            })
            if enabledScripts.count > 0 {
                preferences.scripts.randomItem().runScript()
            }
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
//            print("Detect user activity")
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
