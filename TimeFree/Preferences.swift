//
//  Preferences.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/26/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

final class Preferences: NSObject, NSCoding {
    
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
        static let launchAppAtSystemStartupKey = "launchAppAtSystemStartup"
        static let showPreferencesAtStartAppKey = "showPreferencesAtStartApp"
        static let showNotificationsKey = "showNotifications"
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

    var launchAppAtSystemStartup: Bool {
        didSet {
            synchronize()
        }
    }
    
    var showPreferencesAtStartApp: Bool {
        didSet {
            synchronize()
        }
    }
    
    var showNotifications: Bool {
        didSet {
            synchronize()
        }
    }
    
    // MARK: - Constructors
    override init() {
        dontAllowSleeping = true
        timeoutOfUserActivity = 10
        moveMousePointer = true
        moveMousePointerFrequency = 10
        launchAppAtSystemStartup = true
        showPreferencesAtStartApp = false
        showNotifications = false
        
        super.init()
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dontAllowSleeping, forKey: PropertyKeys.dontAllowSleepingKey)
        aCoder.encode(timeoutOfUserActivity, forKey: PropertyKeys.timeoutOfUserActivityKey)
        aCoder.encode(moveMousePointer, forKey: PropertyKeys.moveMousePointerKey)
        aCoder.encode(moveMousePointerFrequency, forKey: PropertyKeys.moveMousePointerFrequencyKey)
        aCoder.encode(launchAppAtSystemStartup, forKey: PropertyKeys.launchAppAtSystemStartupKey)
        aCoder.encode(showPreferencesAtStartApp, forKey: PropertyKeys.showPreferencesAtStartAppKey)
        aCoder.encode(showNotifications, forKey: PropertyKeys.showNotificationsKey)

    }
    
    required init?(coder aDecoder: NSCoder) {
        dontAllowSleeping = aDecoder.decodeBool(forKey: PropertyKeys.dontAllowSleepingKey)
        timeoutOfUserActivity = aDecoder.decodeInteger(forKey: PropertyKeys.timeoutOfUserActivityKey)
        moveMousePointer = aDecoder.decodeBool(forKey: PropertyKeys.moveMousePointerKey)
        moveMousePointerFrequency = aDecoder.decodeInteger(forKey: PropertyKeys.moveMousePointerFrequencyKey)
        launchAppAtSystemStartup = aDecoder.decodeBool(forKey: PropertyKeys.launchAppAtSystemStartupKey)
        showPreferencesAtStartApp = aDecoder.decodeBool(forKey: PropertyKeys.showPreferencesAtStartAppKey)
        showNotifications = aDecoder.decodeBool(forKey: PropertyKeys.showNotificationsKey)
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
