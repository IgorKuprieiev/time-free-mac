//
//  PowerManager.swift
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

class PowerManager {
    
    // MARK: - Properties
    static var isSleepEnabled: Bool = true
    private static var powerId: IOPMAssertionID = IOPMAssertionID(0)
    
    // MARK: - Public
    static func dontAllowSleeping(disableSleeping: Bool) {
        if disableSleeping == true {
            preventSleep()
        } else {
            releaseSleepAssertion()
        }
    }
    
    // MARK: - Private
    private static func preventSleep() {
        if isSleepEnabled == false {
            print("Sleep already prevented. Releasing existing assertion first.")
            releaseSleepAssertion()
        }
        
        let assertionName = "Keep screen on for set time." as CFString
        let assertionLevel = IOPMAssertionLevel(kIOPMAssertionLevelOn)
        if IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep, assertionLevel, assertionName,  &powerId) == kIOReturnSuccess {
            isSleepEnabled = false
            print("Disable Sleep Mode.")
        }
    }
    
    private static func releaseSleepAssertion() {
        if IOPMAssertionRelease(powerId) == kIOReturnSuccess {
            print("Enable Sleep Mode.")
            isSleepEnabled = true
        }
    }
}
