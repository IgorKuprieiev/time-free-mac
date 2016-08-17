//
//  PowerService.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/26/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Foundation
import CoreFoundation
import IOKit.pwr_mgt

// This isn't defined in Swift, so we cheat and do so here.
let kIOPMAssertionTypeNoDisplaySleep = "PreventUserIdleDisplaySleep" as CFString

enum PowerMode {
    case governedBySystem
    case disableSleeping
}

final class PowerService {
    
    // MARK: - Public Properties
    var powerMode: PowerMode = .governedBySystem {
        didSet {
            if powerMode != oldValue {
                updatePowerSettings()
            }
        }
    }
    // MARK: - Private Properties
    private var powerAssertionId: IOPMAssertionID = 0

    // MARK: - Destructor
    deinit {
        releaseSleepAssertion()
    }
    
    // MARK: - Private methods
    private func updatePowerSettings() {
        switch powerMode {
        case .governedBySystem:
            releaseSleepAssertion()
        case .disableSleeping:
            preventSleep()
        }
    }
    
    private func preventSleep() {
        releaseSleepAssertion()
        
        let assertionName = "Keep screen on for set time." as CFString
        let assertionLevel = IOPMAssertionLevel(kIOPMAssertionLevelOn)
        IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep, assertionLevel, assertionName,  &powerAssertionId)
    }
    
    private func releaseSleepAssertion() {
        IOPMAssertionRelease(powerAssertionId)
    }
}
