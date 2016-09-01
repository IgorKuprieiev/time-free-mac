//
//  EventTracker.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 8/16/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

protocol EventTrackerDelegate: class {
    func didReceiveMouseEvent(_ event: NSEvent)
    func didReceiveKeyboardEvent(_ event: NSEvent)
}

final class EventTracker {
    
    // MARK: - Public Properties
    weak var delegate: EventTrackerDelegate?
    
    // MARK: - Private Properties
    fileprivate lazy var globalMonitors = [AnyObject]()
    
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
    fileprivate func registerMonitors() {
        
        //Register monitors for mouse
        let receivedMouseEventHandler:(NSEvent) -> Void = {[unowned self] (event) in
            self.delegate?.didReceiveMouseEvent(event)
        }
        
        let mouseEventMasks: [NSEventMask] = [.leftMouseDown, .leftMouseUp, .rightMouseUp, .rightMouseDown, .mouseMoved, .scrollWheel, .gesture, .swipe, .rotate, .pressure]
        for eventMask in mouseEventMasks {
            guard let eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: eventMask, handler: receivedMouseEventHandler) else {
                continue
            }
            globalMonitors.append(eventMonitor as AnyObject)
        }
        
        //Register monitors for keyboard
        let receivedKeyboardEventHandler:(NSEvent) -> Void = {[unowned self] (event) in
            self.delegate?.didReceiveKeyboardEvent(event)
        }
        
        let keyboardEventMasks: [NSEventMask] = [.keyDown, .keyUp]
        for eventMask in keyboardEventMasks {
            guard let eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: eventMask, handler: receivedKeyboardEventHandler) else {
                continue
            }
            globalMonitors.append(eventMonitor as AnyObject)
        }
    }
    
    fileprivate func unregisterMonitors() {
        for eventMonitor in globalMonitors {
            NSEvent.removeMonitor(eventMonitor)
        }
        globalMonitors.removeAll()
    }
}
