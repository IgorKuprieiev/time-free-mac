//
//  GeneralPreferencesViewController.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/26/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

class GeneralPreferencesViewController: NSViewController {

    // MARK: - Outlets
    @IBOutlet weak var disableSystemSleepButton: NSButton!
    @IBOutlet weak var randomlyMovingMouseButton: NSButton!
    @IBOutlet weak var movingMouseDelayTextField: NSTextField!
    @IBOutlet weak var automaticallyDisableEventsButton: NSButton!
    
    // MARK: - Properties
    private let preferences = Preferences.sharedPreferences
    
    // MARK: - NSViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
    }
    
    // MARK: - IBActions
    
    @IBAction func disableSystemSleep(sender: NSButton) {
        preferences.disableSystemSleep = (sender.state == NSOnState)
        setupInterface()
    }
    
    @IBAction func randomlyMovingMouse(sender: NSButton) {
        preferences.randomlyMovingMousePointer = (sender.state == NSOnState)
        setupInterface()
    }
    
    @IBAction func movingMouseDelay(sender: NSTextField) {
        if let movingMousePointerDelay = Int(sender.stringValue) {
            preferences.movingMousePointerDelay = movingMousePointerDelay
        }
        setupInterface()
    }

    @IBAction func automaticallyDisableEvents(sender: NSButton) {
        preferences.automaticallyDisableEventsIfUserIsPresent = (sender.state == NSOnState)
        setupInterface()
    }
    
    // MARK: - Private
    func setupInterface() {
        disableSystemSleepButton.state = (preferences.disableSystemSleep == true) ? NSOnState : NSOffState
        randomlyMovingMouseButton.state = (preferences.randomlyMovingMousePointer == true) ? NSOnState : NSOffState
//        movingMouseDelayTextField.enabled = preferences.randomlyMovingMousePointer
//        movingMouseDelayTextField.stringValue = "\(preferences.movingMousePointerDelay)"
        automaticallyDisableEventsButton.state = (preferences.automaticallyDisableEventsIfUserIsPresent == true) ? NSOnState : NSOffState
    }
}
