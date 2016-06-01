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
        static let timeoutOfUserActivityKey = "timeoutOfUserActivity"
        static let moveMousePointerKey = "moveMousePointer"
        static let moveMousePointerFrequencyKey = "moveMousePointerFrequency"
        static let runScriptsKey = "runScripts"
        static let runScriptsFrequencyKey = "runScriptsFrequency"
        static let scriptsKey = "scripts"
    }
    
    // MARK: - Shared Instance
    static let sharedPreferences: Preferences = {
//        if let preferencesData = NSUserDefaults.standardUserDefaults().objectForKey(PropertyKeys.preferencesKey) as? NSData {
//            return NSKeyedUnarchiver.unarchiveObjectWithData(preferencesData) as! Preferences
//        } else {
            return Preferences()
//        }
    }()
    
    private let synchronizePreferencesQueue = dispatch_queue_create("com.timefree.synchronize.preferences.queue", nil)
    
    // MARK: - Properties
    var dontAllowSleeping: Bool {
        didSet {
            synchronizePreferences()
        }
    }
    
    var timeoutOfUserActivity: Int {
        didSet {
            synchronizePreferences()
        }
    }
    
    var moveMousePointer: Bool {
        didSet {
            synchronizePreferences()
        }
    }
    
    var moveMousePointerFrequency: Int {
        didSet {
            synchronizePreferences()
        }
    }

    var runScripts: Bool {
        didSet {
            synchronizePreferences()
        }
    }
    
    var runScriptsFrequency: Int {
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
        timeoutOfUserActivity = 10
        moveMousePointer = false
        moveMousePointerFrequency = 5
        runScripts = true
        runScriptsFrequency = 5
        
//        scripts = [Script]()
//        if let path = NSBundle.mainBundle().pathForResource("DefaultScripts", ofType: "plist") {
//            if let scriptsInfo = NSArray(contentsOfFile: path) {
//                for scriptInfo in scriptsInfo {
//                    
//                }
//
//            }
//            
//        }

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
        aCoder.encodeInteger(timeoutOfUserActivity, forKey: PropertyKeys.timeoutOfUserActivityKey)
        aCoder.encodeBool(moveMousePointer, forKey: PropertyKeys.moveMousePointerKey)
        aCoder.encodeInteger(moveMousePointerFrequency, forKey: PropertyKeys.moveMousePointerFrequencyKey)
        aCoder.encodeBool(runScripts, forKey: PropertyKeys.runScriptsKey)
        aCoder.encodeInteger(runScriptsFrequency, forKey: PropertyKeys.runScriptsFrequencyKey)

        let scriptsData = NSKeyedArchiver.archivedDataWithRootObject(scripts)
        if scriptsData.length > 0 {
            aCoder.encodeObject(scriptsData, forKey:PropertyKeys.scriptsKey)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        dontAllowSleeping = aDecoder.decodeBoolForKey(PropertyKeys.dontAllowSleepingKey)
        timeoutOfUserActivity = aDecoder.decodeIntegerForKey(PropertyKeys.timeoutOfUserActivityKey)
        moveMousePointer = aDecoder.decodeBoolForKey(PropertyKeys.moveMousePointerKey)
        moveMousePointerFrequency = aDecoder.decodeIntegerForKey(PropertyKeys.moveMousePointerFrequencyKey)
        runScripts = aDecoder.decodeBoolForKey(PropertyKeys.runScriptsKey)
        runScriptsFrequency = aDecoder.decodeIntegerForKey(PropertyKeys.runScriptsFrequencyKey)

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
