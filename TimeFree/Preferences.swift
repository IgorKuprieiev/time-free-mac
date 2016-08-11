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
        static let autoLaunchKey = "autoLaunch"
        static let showPreferencesAtStartAppKey = "showPreferencesAtStartApp"
    }
    
    // MARK: - Shared Instance
    static let shared: Preferences = {
        if let preferencesData = UserDefaults.standard.object(forKey: PropertyKeys.preferencesKey) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: preferencesData) as! Preferences
        } else {
            return Preferences()
        }
    }()
    
    // MARK: - Public Properties
    var dontAllowSleeping: Bool {
        didSet {
            synchronize()
        }
    }
    
    var timeoutOfUserActivity: Int {
        didSet {
            synchronize()
        }
    }
    
    var moveMousePointer: Bool {
        didSet {
            synchronize()
        }
    }
    
    var moveMousePointerFrequency: Int {
        didSet {
            synchronize()
        }
    }

    var runScripts: Bool {
        didSet {
            synchronize()
        }
    }
    
    var runScriptsFrequency: Int {
        didSet {
            synchronize()
        }
    }
    
    var scripts: [Script] {
        didSet {
            synchronize()
        }
    }
    
    var autoLaunch: Bool {
        didSet {
            synchronize()
        }
    }
    
    var showPreferencesAtStartApp: Bool {
        didSet {
            synchronize()
        }
    }
    
    // MARK: - Constructors
    override init() {
        dontAllowSleeping = true
        timeoutOfUserActivity = 30
        moveMousePointer = true
        moveMousePointerFrequency = 30
        runScripts = false
        runScriptsFrequency = 30
        autoLaunch = true
        showPreferencesAtStartApp = false
        scripts = {
            let path = Bundle.main.pathForResource("DefaultScripts", ofType: "plist")
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
        aCoder.encode(autoLaunch, forKey: PropertyKeys.autoLaunchKey)
        aCoder.encode(showPreferencesAtStartApp, forKey: PropertyKeys.showPreferencesAtStartAppKey)

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
        autoLaunch = aDecoder.decodeBool(forKey: PropertyKeys.autoLaunchKey)
        showPreferencesAtStartApp = aDecoder.decodeBool(forKey: PropertyKeys.showPreferencesAtStartAppKey)
        
        if let scriptsData = aDecoder.decodeObject(forKey: PropertyKeys.scriptsKey) as? Data {
            scripts = NSKeyedUnarchiver.unarchiveObject(with: scriptsData) as! [Script]
        } else {
            scripts = [Script]()
        }
    }
    
    // MARK: - Private methods
    private func synchronize() {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(archivedData, forKey: PropertyKeys.preferencesKey)
        UserDefaults.standard.synchronize()
        self.noticeThatPreferencesHaveChanged()
    }
    
    private func noticeThatPreferencesHaveChanged() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKeys.propertiesHaveBeenUpdatedKey), object: nil)
    }
}

extension Preferences {
    
    static func usersScriptsPath() -> String? {
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first else {
            return nil
        }
        return documentsPath + "/TimeFree/Scripts/"
    }
}
