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
    @IBOutlet weak var tableView: NSTableView!

    // MARK: - Properties
    private let scripts = Preferences.sharedPreferences.scripts

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        preferredContentSize = NSSize(width: 400, height: 280)
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        Preferences.sharedPreferences.scripts = scripts
    }

//    // MARK: - Private
//    func doubleClickOnRow() {
//        performSegueWithIdentifier("ShowEventDetails", sender: tableView)
//    }
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
        print(object)
        guard let object = object, let tableColumn = tableColumn else {
            return
        }
        
        let script = scripts[row]
        
        switch tableColumn.identifier {
        case TableColumnIdentifiers.enabled:
            script.scriptEnabled = object as! Bool
        case TableColumnIdentifiers.description:
            script.scriptDescription = object as? String
        default:
            return
        }
    }
}