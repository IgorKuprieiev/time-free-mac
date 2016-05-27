//
//  Script.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/25/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Foundation

class Script: NSObject, NSCoding {
    
    // MARK: - PropertyKeys
    private struct PropertyKeys {
        static let scriptSourceKey = "scriptSource"
        static let scriptDescriptionKey = "scriptDescription"
//        static let scriptEnabledKey = "scriptEnabled"
    }
    
    // MARK: - Properties
    var scriptSource: String?
    var scriptDescription: String?
    var scriptEnabled: Bool = true
    
    // MARK: - Initialization
    init(scriptSource: String, scriptDescription: String, scriptEnabled: Bool = true) {
        self.scriptSource = scriptSource
        self.scriptDescription = scriptDescription
//        self.scriptEnabled = scriptEnabled
        
        super.init()
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(scriptSource, forKey: PropertyKeys.scriptSourceKey)
        aCoder.encodeObject(scriptDescription, forKey: PropertyKeys.scriptDescriptionKey)
//        aCoder.encodeBool(scriptEnabled, forKey: PropertyKeys.scriptEnabledKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        scriptSource = aDecoder.decodeObjectForKey(PropertyKeys.scriptSourceKey) as? String
        scriptDescription = aDecoder.decodeObjectForKey(PropertyKeys.scriptDescriptionKey) as? String
//        scriptEnabled = aDecoder.decodeBoolForKey(PropertyKeys.scriptEnabledKey)
    }
    
}