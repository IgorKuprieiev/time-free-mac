//
//  NotificationManager.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 7/18/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Foundation
import Cocoa

final class NotificationManager: NSObject {
    
    // MARK: - Shared Instance
    static let shared = NotificationManager()
    
    // MARK: - Private Properties
    private let defaultSoundName = "Purr"
    
    // MARK: - Constructors
    override init() {
        super.init()
        
        NSUserNotificationCenter.default.delegate = self
    }
    
    // MARK: - Public Properties
    func showNotification(title: String?, details: String? = nil) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = details
        notification.soundName = defaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func playSoundNotification() {
        guard let sound = NSSound(named: defaultSoundName) else {
            return
        }
        sound.play()
    }
}

extension NotificationManager: NSUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
