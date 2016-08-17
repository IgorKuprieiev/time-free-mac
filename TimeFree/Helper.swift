//
//  Helper.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 7/13/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Foundation
import ServiceManagement

private let helperAppBundleId = "com.qarea.timefree.helper"

public func addHelperAppToLoginItems() {
    if SMLoginItemSetEnabled(helperAppBundleId as CFString, true) {
        print("Successfully add login item.")
    } else {
        print("Failed to add login item.")
    }
}

public func removeHelperAppFromLoginItems() {
    if SMLoginItemSetEnabled(helperAppBundleId as CFString, false) {
        NSLog("Successfully remove login item.")
    } else {
        NSLog("Failed to remove login item.")
    }
}
