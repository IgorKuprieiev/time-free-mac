//
//  EventTracker.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 8/16/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

protocol EventTrackerDelegate: class {
    func didReceiveEvent(_ event: NSEvent)
}

final class EventTracker {
    
    // MARK: - Public Properties
    weak var delegate: EventTrackerDelegate?
    
    // MARK: - Private Properties
    private lazy var globalMonitors = [AnyObject]()
    
    // MARK: - Methods of class
    func startTracking() {
        unregisterMonitors()
        registerMonitors()
    }
    
    func stopTracking() {
        unregisterMonitors()
    }

    // MARK: - Initialization
    init(delegate: EventTrackerDelegate? = nil) {
        self.delegate = delegate
    }
    
    // MARK: - Destructor
    deinit {
        unregisterMonitors()
    }

    // MARK: - Private methods
    private func registerMonitors() {
        let receivedEventHandler:(NSEvent) -> Void = {[unowned self] (event) in
            self.delegate?.didReceiveEvent(event)
        }
        
        let eventMasks: [NSEventMask] = [.mouseMoved, .scrollWheel, .keyDown, .gesture, .swipe, .rotate, .pressure]
        for eventMask in eventMasks {
            guard let eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: eventMask, handler: receivedEventHandler) else {
                continue
            }
            globalMonitors.append(eventMonitor as AnyObject)
        }
    }
    
    private func unregisterMonitors() {
        for eventMonitor in globalMonitors {
            NSEvent.removeMonitor(eventMonitor)
        }
        globalMonitors.removeAll()
    }
}
