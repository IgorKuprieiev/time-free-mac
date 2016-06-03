//
//  PreferencesViewController.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 6/2/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    // MARK: - Outlets
    @IBOutlet weak var timeoutOfUserActivitySlider: NSSlider?
    @IBOutlet weak var moveMousePointerFrequencySlider: NSSlider?
    @IBOutlet weak var runScriptsFrequencySlider: NSSlider?
    @IBOutlet weak var scriptsTableView: NSTableView?

    // MARK: - Properties
    private let preferences = Preferences.sharedPreferences
    private var scripts = Preferences.sharedPreferences.scripts

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        
        setupInterface()
    }
    
    // MARK: - IBActions
    @IBAction func timeoutOfUserActivityDidChanged(sender: NSSlider) {
        preferences.timeoutOfUserActivity = sender.integerValue
    }
    
    @IBAction func frequencyOfMovingMouseDidChanged(sender: NSSlider) {
        preferences.moveMousePointerFrequency = sender.integerValue
    }
    
    @IBAction func frequencyOfRunningScriptsDidChanged(sender: NSSlider) {
        preferences.runScriptsFrequency = sender.integerValue
    }
    
    // MARK: - Private
    func setupInterface() {
        timeoutOfUserActivitySlider?.integerValue = preferences.timeoutOfUserActivity
        moveMousePointerFrequencySlider?.integerValue = preferences.moveMousePointerFrequency
        runScriptsFrequencySlider?.integerValue = preferences.runScriptsFrequency
        scriptsTableView?.reloadData()
    }
}

extension PreferencesViewController: NSTableViewDataSource {
    
    // MARK: - TableColumnIdentifiers
    private struct TableColumnIdentifiers {
        static let enabled = "enabled"
        static let description = "description"
    }
    
    // MARK: - NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return scripts.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        guard let tableColumn = tableColumn else {
            return nil
        }
        
        let script = scripts[row]
        
        switch tableColumn.identifier {
        case TableColumnIdentifiers.enabled:
            return script.scriptEnabled
        case TableColumnIdentifiers.description:
            return script.scriptDescription
        default:
            return nil
        }
    }
    
    func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        guard let object = object, let tableColumn = tableColumn else {
            return
        }

        let script = scripts[row]
        
        switch tableColumn.identifier {
        case TableColumnIdentifiers.enabled:
            script.scriptEnabled = object as! Bool
            break
        case TableColumnIdentifiers.description:
            script.scriptDescription = object as? String
            break
        default:
            break
        }
    }
}