//
//  Preferences.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/26/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

class Preferences: NSObject, NSCoding {
    
    // MARK: - NotificationKeys
    struct NotificationKeys {
        static let propertiesHaveBeenUpdatedKey = "PropertiesHaveBeenUpdated"
    }
    
    // MARK: - PreferenceKeys
    private struct PropertyKeys {
        static let preferencesKey = "preferences"
        static let enableManagersKey = "enableManagers"
        static let disableSystemSleepKey = "disableSystemSleep"
        static let randomlyMovingMousePointerKey = "randomlyMovingMousePointer"
        static let movingMousePointerDelayKey = "movingMousePointerDelay"
        static let automaticallyDisableEventsIfUserIsPresentKey = "automaticallyDisableEventsIfUserIsPresent"
    }
    
    // MARK: - Shared Instance
    static let sharedPreferences: Preferences = {
        if let preferencesData = NSUserDefaults.standardUserDefaults().objectForKey(PropertyKeys.preferencesKey) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(preferencesData) as! Preferences
        } else {
            return Preferences()
        }
    }()
    
    // MARK: - Properties
    var disableSystemSleep: Bool {
        didSet {
            synchronizePreferences()
        }
    }
    
    var enableManagers: Bool {
        didSet {
            synchronizePreferences()
        }
    }
    
    var randomlyMovingMousePointer: Bool {
        didSet {
            synchronizePreferences()
        }
    }
    
    var movingMousePointerDelay: Int {
        didSet {
            synchronizePreferences()
        }
    }

    var automaticallyDisableEventsIfUserIsPresent: Bool {
        didSet {
            synchronizePreferences()
        }
    }
    
    // MARK: - Initialization
    override init() {
        enableManagers = false
        disableSystemSleep = true
        randomlyMovingMousePointer = true
        movingMousePointerDelay = 30
        automaticallyDisableEventsIfUserIsPresent = true
        
        super.init()
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(enableManagers, forKey: PropertyKeys.enableManagersKey)
        aCoder.encodeBool(disableSystemSleep, forKey: PropertyKeys.disableSystemSleepKey)
        aCoder.encodeBool(randomlyMovingMousePointer, forKey: PropertyKeys.randomlyMovingMousePointerKey)
        aCoder.encodeInteger(movingMousePointerDelay, forKey: PropertyKeys.movingMousePointerDelayKey)
        aCoder.encodeBool(automaticallyDisableEventsIfUserIsPresent, forKey: PropertyKeys.automaticallyDisableEventsIfUserIsPresentKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        enableManagers = aDecoder.decodeBoolForKey(PropertyKeys.enableManagersKey)
        disableSystemSleep = aDecoder.decodeBoolForKey(PropertyKeys.disableSystemSleepKey)
        randomlyMovingMousePointer = aDecoder.decodeBoolForKey(PropertyKeys.randomlyMovingMousePointerKey)
        movingMousePointerDelay = aDecoder.decodeIntegerForKey(PropertyKeys.movingMousePointerDelayKey)
        automaticallyDisableEventsIfUserIsPresent = aDecoder.decodeBoolForKey(PropertyKeys.automaticallyDisableEventsIfUserIsPresentKey)
    }
    
    // MARK: - Private
    private func synchronizePreferences() {
        let archivedData = NSKeyedArchiver.archivedDataWithRootObject(self)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(archivedData, forKey: PropertyKeys.preferencesKey)
        userDefaults.synchronize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.propertiesHaveBeenUpdatedKey, object: nil)
    }
}
