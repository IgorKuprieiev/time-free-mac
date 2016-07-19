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
        static let scriptEnabledKey = "scriptEnabled"
    }
    
    // MARK: - Properties
    var scriptSource: String?
    var scriptDescription: String?
    var scriptEnabled: Bool = true
    
    // MARK: - Initialization
    init(scriptSource: String?, scriptDescription: String?, scriptEnabled: Bool = true) {
        self.scriptSource = scriptSource
        self.scriptDescription = scriptDescription
        self.scriptEnabled = scriptEnabled
        
        super.init()
    }
    
    convenience init?(info: NSDictionary?) {
        guard let info = info else {
            return nil
        }
        
        self.init(scriptSource: info[PropertyKeys.scriptSourceKey] as? String,
                  scriptDescription: info[PropertyKeys.scriptDescriptionKey] as? String,
                  scriptEnabled: info[PropertyKeys.scriptEnabledKey] as! Bool)
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(scriptSource, forKey: PropertyKeys.scriptSourceKey)
        aCoder.encode(scriptDescription, forKey: PropertyKeys.scriptDescriptionKey)
        aCoder.encode(scriptEnabled, forKey: PropertyKeys.scriptEnabledKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        scriptSource = aDecoder.decodeObject(forKey: PropertyKeys.scriptSourceKey) as? String
        scriptDescription = aDecoder.decodeObject(forKey: PropertyKeys.scriptDescriptionKey) as? String
        scriptEnabled = aDecoder.decodeBool(forKey: PropertyKeys.scriptEnabledKey)
    }
}

extension Script {
    
    @discardableResult func runScript() -> Bool {
        guard let scriptSource = self.scriptSource else {
            return false
        }
        guard let appleScript = NSAppleScript(source: scriptSource) else {
            return false
        }
        print("Run script \"\(scriptDescription)\"")
        var error: NSDictionary? = nil
        if let output: NSAppleEventDescriptor = appleScript.executeAndReturnError(&error) {
            if output.stringValue?.characters.count > 0 {
                print("Output: \(output.stringValue)")
            }
            return true
        } else {
            if (error != nil) {
                print("Error: \(error)")
            }
            return false
        }
    }
}

extension Script {
    
    static func scriptsFromFile(_ path: String?) -> [Script] {
        var scripts = [Script]()
        
        guard let path = path else {
            return scripts
        }
        
        guard let scriptsInfo = NSArray(contentsOfFile: path) else {
            return scripts
        }
        
        for scriptInfo in scriptsInfo {
            if let script = Script(info: scriptInfo as? NSDictionary) {
                scripts.append(script)
            }
        }
        return scripts
    }
    
}
