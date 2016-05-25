//
//  Event.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/25/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Foundation

public enum EventType: Int {
    case RandomMousePosition
    case AppleScript
}

class Event: NSObject, NSCoding {
    
    // MARK: - PropertyKeys
    private struct PropertyKeys {
        static let eventTypeKey = "eventType"
        static let timeIntervalKey = "timeInterval"
        static let additionalInfoKey = "additionalInfo"
    }
    
    // MARK: - Properties
    var eventType: EventType
    var timeInterval: Int
    var additionalInfo: String?
    
    // MARK: - Initialization
    init(eventType: EventType, timeInterval: Int, additionalInfo: String? = nil) {
        self.eventType = eventType
        self.timeInterval = timeInterval
        self.additionalInfo = additionalInfo
        super.init()
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(eventType.rawValue, forKey: PropertyKeys.eventTypeKey)
        aCoder.encodeInteger(timeInterval, forKey: PropertyKeys.timeIntervalKey)
        if let additionalInfo = additionalInfo {
            aCoder.encodeObject(additionalInfo, forKey: PropertyKeys.additionalInfoKey)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        eventType = EventType(rawValue: aDecoder.decodeIntegerForKey(PropertyKeys.eventTypeKey))!
        timeInterval = aDecoder.decodeIntegerForKey(PropertyKeys.timeIntervalKey)
        additionalInfo = aDecoder.decodeObjectForKey(PropertyKeys.additionalInfoKey) as? String
    }
    
}