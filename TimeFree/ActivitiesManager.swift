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
    
    deinit {
        stopActivities()
    }
    
    // MARK: - Public
    func startActivities() {
        stopActivities()
        globalTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(globalTimerTickDuration),
                                                             target: self,
                                                             selector: #selector(ActivitiesManager.globalTick),
                                                             userInfo: nil,
                                                             repeats: true)
    }
    
    func stopActivities() {
        guard globalTimer != nil else {
            return
        }
        globalTimer!.invalidate()
        globalTimer = nil
    }
    
    @objc func globalTick() {
        globalTickCounter += globalTimerTickDuration
        
        //Move mouse
        if (preferences.randomlyMovingMousePointer == true && (preferences.movingMousePointerDelay % globalTickCounter) == 0) {
            MouseManager.moveMousePointerToRandomPosition()
        }
        
    }
    
    // MARK: - Private
    private func registrationObservers() {
    
    }
    
    private func unregisterObservers() {
        
    }
    
    func propertiesHaveBeenUpdated(notification: NSNotification) {
        
    }
    
}
