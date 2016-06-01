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
        static let dontAllowSleepingKey = "dontAllowSleeping"
        static let moveMousePointerKey = "moveMousePointer"
        static let movingMousePointerDelayKey = "movingMousePointerDelay"
        static let runScriptsKey = "runScripts"
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
    
    private let synchronizePreferencesQueue = dispatch_queue_create("com.timefree.synchronize.preferences.queue", nil)
    
    // MARK: - Properties
    var dontAllowSleeping: Bool {
        didSet {
            synchronizePreferences()
        }
    }
    
    var moveMousePointer: Bool {
        didSet {
            synchronizePreferences()
        }
    }
    
    var movingMousePointerDelay: Int {
        didSet {
            synchronizePreferences()
        }
    }

    var runScripts: Bool {
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
        dontAllowSleeping = false
        moveMousePointer = false
        movingMousePointerDelay = 5
        runScripts = true
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
        aCoder.encodeBool(dontAllowSleeping, forKey: PropertyKeys.dontAllowSleepingKey)
        aCoder.encodeBool(moveMousePointer, forKey: PropertyKeys.moveMousePointerKey)
        aCoder.encodeInteger(movingMousePointerDelay, forKey: PropertyKeys.movingMousePointerDelayKey)
        aCoder.encodeBool(runScripts, forKey: PropertyKeys.runScriptsKey)
        aCoder.encodeInteger(timeoutOfUserActivity, forKey: PropertyKeys.timeoutOfUserActivityKey)
        
        let scriptsData = NSKeyedArchiver.archivedDataWithRootObject(scripts)
        if scriptsData.length > 0 {
            aCoder.encodeObject(scriptsData, forKey:PropertyKeys.scriptsKey)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        dontAllowSleeping = aDecoder.decodeBoolForKey(PropertyKeys.dontAllowSleepingKey)
        moveMousePointer = aDecoder.decodeBoolForKey(PropertyKeys.moveMousePointerKey)
        movingMousePointerDelay = aDecoder.decodeIntegerForKey(PropertyKeys.movingMousePointerDelayKey)
        runScripts = aDecoder.decodeBoolForKey(PropertyKeys.runScriptsKey)
        timeoutOfUserActivity = aDecoder.decodeIntegerForKey(PropertyKeys.timeoutOfUserActivityKey)
        
        if let scriptsData = aDecoder.decodeObjectForKey(PropertyKeys.scriptsKey) as? NSData {
            scripts = NSKeyedUnarchiver.unarchiveObjectWithData(scriptsData) as! [Script]
        } else {
            scripts = [Script]()
        }
    }
    
    // MARK: - Private
    private func synchronizePreferences() {
//        dispatch_sync(synchronizePreferencesQueue) { 
            let archivedData = NSKeyedArchiver.archivedDataWithRootObject(self)
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(archivedData, forKey: PropertyKeys.preferencesKey)
            userDefaults.synchronize()
//            dispatch_sync(dispatch_get_main_queue()) {
                self.noticeThatPreferencesHaveChanged()
//            }
//        }
    }
    
    private func noticeThatPreferencesHaveChanged() {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.propertiesHaveBeenUpdatedKey, object: nil)
    }
}
