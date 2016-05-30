//
//  Preferences.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/26/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

class Preferences: NSObject, NSCoding {
    
    // MARK: - PreferenceKeys
    private struct PropertyKeys {
        static let preferencesKey = "preferences"
        static let enableManagersKey = "enableManagers"
        static let disableSystemSleepKey = "disableSystemSleep"
        static let randomlyMovingMousePointerKey = "randomlyMovingMousePointer"
        static let movingMousePointerDelayKey = "movingMousePointerDelay"
        static let automaticallyDisableEventsIfUserIsPresentKey = "automaticallyDisableEventsIfUserIsPresent"
        static let timeoutOfUserActivityKey = "timeoutOfUserActivity"
        static let scriptsKey = "scripts"
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
    
    var timeoutOfUserActivity: Int {
        didSet {
            synchronizePreferences()
        }
    }
    
    var scripts: [Script] {
        didSet {
            synchronizePreferences()
        }
    }

    // MARK: - Initialization
    override init() {
        enableManagers = false
        disableSystemSleep = true
        randomlyMovingMousePointer = true
        movingMousePointerDelay = 5
        automaticallyDisableEventsIfUserIsPresent = true
        timeoutOfUserActivity = 5

        scripts = {
            let source1 = "tell application \"System Events\"\n" +
            "if exists process \"Xcode\" then\n" +
            "tell application \"Xcode\"\n" +
            "activate\n" +
            "end tell\n" +
            "tell process \"Xcode\"\n" +
            "keystroke \"}\" using {command down, shift down}\n" +
            "end tell\n" +
            "end if\n" +
        "end tell"
        let testScript1 = Script(scriptSource: source1, scriptDescription: "TestDescription")
//        
//        let source2 = "tell application \"System Events\"\n" +
//            "if exists process \"Xcode\" then\n" +
//            "tell application \"Xcode\"\n" +
//            "activate\n" +
//            "end tell\n" +
//            "tell process \"Xcode\"\n" +
//            "keystroke \"}\" using {command down, shift down}\n" +
//            "end tell\n" +
//            "end if\n" +
//        "end tell"
//        let testScript2 = Script(scriptSource: source2, scriptDescription: "TestDescription")
//        
//        let source3 = "tell application \"System Events\"\n" +
//            "if exists process \"Xcode\" then\n" +
//            "tell application \"Xcode\"\n" +
//            "activate\n" +
//            "end tell\n" +
//            "tell process \"Xcode\"\n" +
//            "keystroke \"}\" using {command down, shift down}\n" +
//            "end tell\n" +
//            "end if\n" +
//        "end tell"
//        let testScript3 = Script(scriptSource: source3, scriptDescription: "TestDescription")
        
        return [testScript1]
        }()
        
        super.init()
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(enableManagers, forKey: PropertyKeys.enableManagersKey)
        aCoder.encodeBool(disableSystemSleep, forKey: PropertyKeys.disableSystemSleepKey)
        aCoder.encodeBool(randomlyMovingMousePointer, forKey: PropertyKeys.randomlyMovingMousePointerKey)
        aCoder.encodeInteger(movingMousePointerDelay, forKey: PropertyKeys.movingMousePointerDelayKey)
        aCoder.encodeBool(automaticallyDisableEventsIfUserIsPresent, forKey: PropertyKeys.automaticallyDisableEventsIfUserIsPresentKey)
        aCoder.encodeInteger(timeoutOfUserActivity, forKey: PropertyKeys.timeoutOfUserActivityKey)
        
        let scriptsData = NSKeyedArchiver.archivedDataWithRootObject(scripts)
        if scriptsData.length > 0 {
            aCoder.encodeObject(scriptsData, forKey:PropertyKeys.scriptsKey)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        enableManagers = aDecoder.decodeBoolForKey(PropertyKeys.enableManagersKey)
        disableSystemSleep = aDecoder.decodeBoolForKey(PropertyKeys.disableSystemSleepKey)
        randomlyMovingMousePointer = aDecoder.decodeBoolForKey(PropertyKeys.randomlyMovingMousePointerKey)
        movingMousePointerDelay = aDecoder.decodeIntegerForKey(PropertyKeys.movingMousePointerDelayKey)
        automaticallyDisableEventsIfUserIsPresent = aDecoder.decodeBoolForKey(PropertyKeys.automaticallyDisableEventsIfUserIsPresentKey)
        timeoutOfUserActivity = aDecoder.decodeIntegerForKey(PropertyKeys.timeoutOfUserActivityKey)
        
        if let scriptsData = aDecoder.decodeObjectForKey(PropertyKeys.scriptsKey) as? NSData {
            scripts = NSKeyedUnarchiver.unarchiveObjectWithData(scriptsData) as! [Script]
        } else {
            scripts = [Script]()
        }
    }
    
    // MARK: - Private
    private func synchronizePreferences() {
        let archivedData = NSKeyedArchiver.archivedDataWithRootObject(self)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(archivedData, forKey: PropertyKeys.preferencesKey)
        userDefaults.synchronize()
    }
}
