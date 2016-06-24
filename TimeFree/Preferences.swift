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
        if let preferencesData = UserDefaults.standard().object(forKey: PropertyKeys.preferencesKey) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: preferencesData) as! Preferences
        } else {
            return Preferences()
        }
    }()
    
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
        timeoutOfUserActivity = 30
        moveMousePointer = false
        moveMousePointerFrequency = 30
        runScripts = true
        runScriptsFrequency = 30
        scripts = {
            let path = Bundle.main().pathForResource("DefaultScripts", ofType: "plist")
            return Script.scriptsFromFile(path)
        }()
        
        super.init()
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dontAllowSleeping, forKey: PropertyKeys.dontAllowSleepingKey)
        aCoder.encode(timeoutOfUserActivity, forKey: PropertyKeys.timeoutOfUserActivityKey)
        aCoder.encode(moveMousePointer, forKey: PropertyKeys.moveMousePointerKey)
        aCoder.encode(moveMousePointerFrequency, forKey: PropertyKeys.moveMousePointerFrequencyKey)
        aCoder.encode(runScripts, forKey: PropertyKeys.runScriptsKey)
        aCoder.encode(runScriptsFrequency, forKey: PropertyKeys.runScriptsFrequencyKey)

        let scriptsData = NSKeyedArchiver.archivedData(withRootObject: scripts)
        if scriptsData.count > 0 {
            aCoder.encode(scriptsData, forKey:PropertyKeys.scriptsKey)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        dontAllowSleeping = aDecoder.decodeBool(forKey: PropertyKeys.dontAllowSleepingKey)
        timeoutOfUserActivity = aDecoder.decodeInteger(forKey: PropertyKeys.timeoutOfUserActivityKey)
        moveMousePointer = aDecoder.decodeBool(forKey: PropertyKeys.moveMousePointerKey)
        moveMousePointerFrequency = aDecoder.decodeInteger(forKey: PropertyKeys.moveMousePointerFrequencyKey)
        runScripts = aDecoder.decodeBool(forKey: PropertyKeys.runScriptsKey)
        runScriptsFrequency = aDecoder.decodeInteger(forKey: PropertyKeys.runScriptsFrequencyKey)

        if let scriptsData = aDecoder.decodeObject(forKey: PropertyKeys.scriptsKey) as? Data {
            scripts = NSKeyedUnarchiver.unarchiveObject(with: scriptsData) as! [Script]
        } else {
            scripts = [Script]()
        }
    }
    
    // MARK: - Private
    private func synchronizePreferences() {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        let userDefaults = UserDefaults.standard()
        userDefaults.set(archivedData, forKey: PropertyKeys.preferencesKey)
        userDefaults.synchronize()
        self.noticeThatPreferencesHaveChanged()
    }
    
    private func noticeThatPreferencesHaveChanged() {
        NotificationCenter.default().post(name: Notification.Name(rawValue: NotificationKeys.propertiesHaveBeenUpdatedKey), object: nil)
    }
}
