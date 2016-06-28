//
//  ActivityManager.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/27/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

// MARK: - ActivitiesManagerDelegate
protocol TriggerDelegate: class {
    
    // MARK: - Methods of instance
    func didStartActivities()
    func didPausedActivities()
    func triggerTick(trigger: Trigger)
}

// MARK: - ActivitiesManager
class Trigger: AnyObject {
    
    // MARK: - Public Properties
    weak var delegate: TriggerDelegate?
    var triggerTickDuration = 5
    var tickCounter = 0
    var timeoutOfUserActivity = 0
    
    // MARK: - Private Properties
    private var timer: Timer? = nil
    private lazy var globalMonitors = [AnyObject]()
    
    deinit {
        stop()
    }
    
    // MARK: - Public
    func start() {
        //Invalidate previous timer
        stop()
        
        //Enable a user's observation
        if timeoutOfUserActivity > 0 {
            registrationObservers()
        }
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(triggerTickDuration),
                                     target: self,
                                     selector: #selector(Trigger.tick),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stop() {
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
        tickCounter += triggerTickDuration
        
        //Disable the simulation, if there is user activity
        if tickCounter < timeoutOfUserActivity {
            return
        } else if tickCounter == timeoutOfUserActivity {
            delegate?.didStartActivities()
        }
        
        delegate?.triggerTick(trigger: self)
    }
    
    // MARK: - Private methods
    private func resetTickCounter() {
        print("reset tick counter")
        if tickCounter > timeoutOfUserActivity {
            delegate?.didStartActivities()
        }
        tickCounter = 0
    }
    
    private func registrationObservers() {
        //Check grant access
        let options = NSDictionary(object: kCFBooleanTrue,
                                   forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString) as CFDictionary
        guard AXIsProcessTrustedWithOptions(options) == true else {
            print("Grant access to this application in Security & Privacy preferences, located in System Preferences.")
            return
        }
        
        //Action after user activity
        let handler:(NSEvent) -> Void = {[weak self] (event) in
            guard let strongSelf = self else {
                return
            }
            
            //Reset counter
            strongSelf.resetTickCounter()
        }
        
        //Run monitors
        let eventMasks: [NSEventMask] = [.mouseMoved,
                                         .scrollWheel,
                                         .keyDown,
                                         .gesture,
                                         .swipe,
                                         .rotate,
                                         .pressure]
        for eventMask in eventMasks {
            if let eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: eventMask, handler: handler) {
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
