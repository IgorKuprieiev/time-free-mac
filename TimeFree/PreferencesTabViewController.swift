//
//  PreferencesTabViewController.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 8/15/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

class PreferencesTabViewController: NSTabViewController {

    // MARK: - NSViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = NSSize(width: 560, height: 260)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        guard let delegate = NSApplication.shared().delegate as? AppDelegate? else {
            return
        }
        
        delegate?.servicesManager.resetAllServices()
    }
}
