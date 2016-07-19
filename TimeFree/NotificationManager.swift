//
//  NotificationManager.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 7/18/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Foundation

class NotificationManager: NSObject {
    
    // MARK: - Shared Instance
    static let shared: NotificationManager = {
        return NotificationManager()
    }()
    
    // MARK: - Constructors
    override init() {
        super.init()
        
        NSUserNotificationCenter.default.delegate = self
    }
    
    // MARK: - Public Properties
    func showNotification(title: String?, informativeText: String?) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = informativeText
        notification.soundName = "Hero"
        NSUserNotificationCenter.default.deliver(notification)
    }
}

extension NotificationManager: NSUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
