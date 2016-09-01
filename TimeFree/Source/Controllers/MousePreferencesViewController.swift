//
//  MousePreferencesViewController.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 8/12/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

final class MousePreferencesViewController: NSViewController {

    // MARK: - Outlets
    @IBOutlet weak var moveMousePointerFrequencySlider: NSSlider!
    @IBOutlet weak var moveMousePointerFrequencyTextField: NSTextField!
    
    // MARK: - Private Properties
    fileprivate lazy var dateComponentsFormatter: DateComponentsFormatter = {
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
    @IBAction func changingMoveMousePointerFrequencySlider(_ sender: NSSlider) {
        Preferences.shared.moveMousePointerFrequency = sender.integerValue
        updateTextFields()
    }
    
    // MARK: - Private methods
    fileprivate func prepareControls() {
        moveMousePointerFrequencySlider?.integerValue = Preferences.shared.moveMousePointerFrequency
    }
    
    fileprivate func updateTextFields() {
        let timeoutOfUserActivitySliderValue = moveMousePointerFrequencySlider.integerValue
        moveMousePointerFrequencyTextField.stringValue = dateComponentsFormatter.string(from: Double(timeoutOfUserActivitySliderValue))!
    }
}
