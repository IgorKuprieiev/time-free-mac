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
    @IBOutlet weak var autoLaunchButton: NSButton?
    @IBOutlet weak var showPreferencesAtStartAppButton: NSButton?

    // MARK: - Properties
    private var scripts = Preferences.shared.scripts

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        
        setupInterface()
    }
    
    // MARK: - IBActions
    @IBAction func timeoutOfUserActivityDidChanged(_ sender: NSSlider) {
        Preferences.shared.timeoutOfUserActivity = sender.integerValue
    }
    
    @IBAction func frequencyOfMovingMouseDidChanged(_ sender: NSSlider) {
        Preferences.shared.moveMousePointerFrequency = sender.integerValue
    }
    
    @IBAction func frequencyOfRunningScriptsDidChanged(_ sender: NSSlider) {
        Preferences.shared.runScriptsFrequency = sender.integerValue
    }
    
    @IBAction func autoLaunch(_ sender: NSButton) {
        Preferences.shared.autoLaunch = (sender.state == NSOnState)
    }

    @IBAction func showPreferencesAtStartApp(_ sender: NSButton) {
        Preferences.shared.showPreferencesAtStartApp = (sender.state == NSOnState)
    }
    
    // MARK: - Private
    func setupInterface() {
        timeoutOfUserActivitySlider?.integerValue = Preferences.shared.timeoutOfUserActivity
        moveMousePointerFrequencySlider?.integerValue = Preferences.shared.moveMousePointerFrequency
        runScriptsFrequencySlider?.integerValue = Preferences.shared.runScriptsFrequency
        autoLaunchButton?.state = Preferences.shared.autoLaunch == true ? NSOnState : NSOffState
        showPreferencesAtStartAppButton?.state = Preferences.shared.showPreferencesAtStartApp == true ? NSOnState : NSOffState
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
    func numberOfRows(in tableView: NSTableView) -> Int {
        return scripts.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
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
    
    func tableView(_ tableView: NSTableView, setObjectValue object: AnyObject?, for tableColumn: NSTableColumn?, row: Int) {
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
