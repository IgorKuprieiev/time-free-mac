//
//  TimeCounter.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/27/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

protocol TimeCounterDelegate: class {
    
    func didTick(_ tickCount: UInt64)
}

final class TimeCounter {
    
    // MARK: - Public Properties
    weak var delegate: TimeCounterDelegate?
    private(set) var tickDuration: UInt64 = 5
    var tickCount: UInt64 = 0
    
    // MARK: - Private Properties
    private var timer: Timer? = nil
    
    // MARK: - Initialization
    init(delegate: TimeCounterDelegate? = nil) {
        self.delegate = delegate
    }
    
    // MARK: - Destructor
    deinit {
        destroyTimer()
    }
    
    // MARK: - Methods of instance
    func reset() {
        start()
    }
    
    func start() {
        //Invalidate previous timer
        destroyTimer()
        
        //Reset counter
        resetTickCount()
        
        //Create new timer
        initializeTimer()
    }
    
    func stop() {
        //Invalidate timer
        destroyTimer()
    }
    
    func resetTickCount() {
        tickCount = 0
    }

    // MARK: - Private methods
    fileprivate func initializeTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(tickDuration),
                                     target: self,
                                     selector: #selector(TimeCounter.tick),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    fileprivate func destroyTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func tick() {
        tickCount += tickDuration
        
        delegate?.didTick(tickCount)
    }
}
