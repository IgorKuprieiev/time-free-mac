//
//  GeneralPreferencesViewController.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 8/12/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

final class GeneralPreferencesViewController: NSViewController {

    // MARK: - Outlets
    @IBOutlet weak var timeoutOfUserActivitySlider: NSSlider!
    @IBOutlet weak var timeoutOfUserActivityTextField: NSTextField!
    @IBOutlet weak var showNotificationsButton: NSButton!
    @IBOutlet weak var launchAppAtSystemStartupButton: NSButton!

    // MARK: - Private Properties
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    // MARK: - NSViewController
    override func viewWillAppear() {
        super.viewWillAppear()
        
        prepareControls()
        updateTextFields()
    }
    
    // MARK: - Actions
    @IBAction func changingValueInTimeoutOfUserActivitySlider(_ sender: NSSlider) {
        Preferences.shared.timeoutOfUserActivity = sender.integerValue
        updateTextFields()
    }
    
    @IBAction func selectShowNotificationsButton(_ sender: NSButton) {
        Preferences.shared.showNotifications = (sender.state == NSOnState)
    }
    
    @IBAction func selectLaunchAppAtSystemStartupButton(_ sender: NSButton) {
        Preferences.shared.launchAppAtSystemStartup = (sender.state == NSOnState)
    }

    // MARK: - Private methods
    private func prepareControls() {
        timeoutOfUserActivitySlider?.integerValue = Preferences.shared.timeoutOfUserActivity
        launchAppAtSystemStartupButton?.state = Preferences.shared.launchAppAtSystemStartup == true ? NSOnState : NSOffState
        showNotificationsButton?.state = Preferences.shared.showNotifications == true ? NSOnState : NSOffState
    }
    
    private func updateTextFields() {
        let timeoutOfUserActivitySliderValue = timeoutOfUserActivitySlider.integerValue
        if timeoutOfUserActivitySliderValue > 0 {
            timeoutOfUserActivityTextField.stringValue = dateComponentsFormatter.string(from: Double(timeoutOfUserActivitySliderValue))!
        } else {
            timeoutOfUserActivityTextField.stringValue = NSLocalizedString("Newer", comment: "")
        }
    }
}
